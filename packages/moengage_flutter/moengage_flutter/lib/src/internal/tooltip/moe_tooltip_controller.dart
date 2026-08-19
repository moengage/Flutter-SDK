import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

import '../designmode/element_inspector.dart';
import '../designmode/element_node.dart';
import '../designmode/element_tag_builder.dart';

/// Selects how the element tooltip is rendered once a hardcoded/backend
/// campaign matches the active screen.
enum TooltipRenderMode {
  /// Native draws the tooltip itself (e.g. via a window overlay) and
  /// positions it using bounds sent over the method channel. The tooltip is
  /// not part of Flutter's own widget/compositing tree.
  nativeOverlay,

  /// The tooltip is a native `PlatformView` embedded directly in the Flutter
  /// widget tree, positioned by Dart with a [Positioned] + `AndroidView`.
  platformView,
}

/// A single anchor-to-tooltip mapping: whenever [screenName] becomes the
/// active screen, a tooltip reading [message] is anchored to the widget
/// carrying `ValueKey<String>(nodeId)`.
class _TooltipCampaign {
  const _TooltipCampaign({
    required this.screenName,
    required this.nodeId,
    required this.message,
    this.overlayType = NativeTooltipOverlayType.tooltip,
  });

  final String screenName;
  final String nodeId;
  final String message;

  /// Which native `com.moengage:tooltip` overlay to render for this
  /// campaign. Only used under [TooltipRenderMode.nativeOverlay] - the
  /// [TooltipRenderMode.platformView] mode always renders its own bubble.
  final NativeTooltipOverlayType overlayType;
}

/// One target of a coach mark campaign: the widget to highlight and its copy.
class _CoachMarkStepSpec {
  const _CoachMarkStepSpec({
    required this.nodeId,
    required this.text,
    this.cutoutCornerRadius = 8,
  });

  final String nodeId;
  final String text;
  final double cutoutCornerRadius;
}

/// A coach mark campaign: several elements highlighted together on one overlay
/// when [screenName] becomes active.
///
/// Kept separate from [_TooltipCampaign] rather than bolting a step list onto
/// it - the single-element overlays resolve one anchor and the coach mark
/// resolves many, so one shape would leave half its fields unused either way.
class _CoachMarkCampaign {
  const _CoachMarkCampaign({required this.screenName, required this.steps});

  final String screenName;
  final List<_CoachMarkStepSpec> steps;
}

/// Resolved, currently-visible tooltip state for [TooltipRenderMode.platformView]
/// - the logical-pixel rect the anchor widget occupies (the `PlatformView` is
/// positioned just below it) and the copy to render.
class VisibleTooltip {
  /// [VisibleTooltip] Constructor
  const VisibleTooltip({required this.anchorRect, required this.message});

  /// Anchor widget's bounds, in logical pixels.
  final Rect anchorRect;

  /// Tooltip copy to render.
  final String message;
}

/// Watches for screen changes and, when the active screen has a matching
/// campaign, resolves the target widget by its node id and shows a tooltip
/// anchored to it - either natively (see [TooltipRenderMode.nativeOverlay])
/// or as a Flutter-embedded `PlatformView` (see [TooltipRenderMode.platformView]),
/// selected via [renderMode].
///
// TODO(moengage): replace [_campaigns] with campaigns fetched from the
// backend once that pipeline exists; for now the anchors are hardcoded to
// the sample app's Cards and InApp screens.
class MoETooltipController extends ChangeNotifier {
  /// Factory Constructor
  factory MoETooltipController.instance() => _instance;

  MoETooltipController._internal();

  static final MoETooltipController _instance =
      MoETooltipController._internal();

  static const Duration _autoDismissDelay = Duration(seconds: 4);

  static const List<_TooltipCampaign> _campaigns = <_TooltipCampaign>[
    _TooltipCampaign(
      screenName: 'CardsHome',
      nodeId: 'cards_home_anchor',
      message: 'Check out your Cards here!',
    ),
    _TooltipCampaign(
      screenName: 'InAppHomeScreen',
      nodeId: 'inapp_home_anchor',
      message: 'Trigger an InApp campaign from here!',
      overlayType: NativeTooltipOverlayType.tooltip,
    ),
    _TooltipCampaign(
      screenName: 'PersonalizeHome',
      nodeId: 'personalize_home_anchor',
      message: 'Start by fetching your experience meta.',
      overlayType: NativeTooltipOverlayType.spotlight,
    ),
  ];

  /// Hardcoded coach mark campaigns, alongside [_campaigns] for the same reason
  /// - a stand-in until the backend delivers them.
  static const List<_CoachMarkCampaign> _coachMarkCampaigns =
      <_CoachMarkCampaign>[
    _CoachMarkCampaign(
      screenName: 'CoachMarkDemo',
      steps: <_CoachMarkStepSpec>[
        _CoachMarkStepSpec(
          nodeId: 'coach_search',
          text: 'Search starts here.',
          cutoutCornerRadius: 28,
        ),
        _CoachMarkStepSpec(
          nodeId: 'coach_cart',
          text: 'Your cart lives here.',
          cutoutCornerRadius: 12,
        ),
        _CoachMarkStepSpec(
          nodeId: 'coach_profile',
          text: 'And your profile here.',
          cutoutCornerRadius: 12,
        ),
      ],
    ),
  ];

  MoEngageFlutterPlatform get _platform => MoEngageFlutterPlatform.instance;

  Element? _root;
  Timer? _autoDismissTimer;

  /// Selects how a matched campaign's tooltip is rendered.
  TooltipRenderMode renderMode = TooltipRenderMode.platformView;

  /// The tooltip currently visible under [TooltipRenderMode.platformView],
  /// or `null` if none is showing. Ignored under [TooltipRenderMode.nativeOverlay].
  VisibleTooltip? current;

  /// The element a native tooltip is currently anchored to, so [notifyScrolled]
  /// can re-measure it and move the overlay. `null` when nothing is showing, or
  /// when the showing overlay is one that cannot be re-anchored - see
  /// [_isFollowable].
  ElementNode? _followedNode;

  /// Which overlay [_followedNode] is showing, so the anchor update reaches the
  /// right native object - the tooltip and the beacon are separate views with
  /// separate re-anchor calls.
  NativeTooltipOverlayType _followedOverlayType =
      NativeTooltipOverlayType.tooltip;

  /// Last bounds reported for [_followedNode], so a scroll that didn't actually
  /// move the element sends nothing.
  Rect? _lastReportedBounds;

  /// Whether a coach mark overlay is on screen, so [dismiss] only asks native to
  /// close one when there is something to close.
  bool _coachMarksShowing = false;

  /// Registers the root [Element] campaign anchors should be resolved under.
  /// Called by the wrapper widget after every frame, mirroring
  /// [DesignModeController.attach].
  void attach(Element root) {
    _root = root;
  }

  /// Checks [screenName] against the hardcoded campaign list and, on a
  /// match, resolves the anchor widget and shows a tooltip for it using
  /// [renderMode]. No-op if there's no campaign for this screen or its
  /// anchor widget isn't currently mounted.
  void onScreenChanged(String screenName) {
    final Element? root = _root;
    if (root == null) return;
    for (final _TooltipCampaign campaign in _campaigns) {
      if (campaign.screenName != screenName) continue;
      final double pixelRatio = _pixelRatio;
      final ElementNode? node =
          ElementInspector.findByNodeId(root, campaign.nodeId, pixelRatio);
      if (node == null) {
        debugPrint(
          'MoETooltipController: no mounted widget with nodeId '
          '"${campaign.nodeId}" found on screen "$screenName" - skipping.',
        );
        continue;
      }
      // A PlatformView renders its own speech bubble inside the widget tree,
      // which is only meaningful for `tooltip`. A beacon is anchored chrome and
      // a spotlight dims the whole screen - neither has a bubble equivalent, so
      // rendering one would silently show the wrong overlay. Those two always
      // take the native path regardless of [renderMode].
      final bool useNativeOverlay =
          renderMode == TooltipRenderMode.nativeOverlay ||
              campaign.overlayType != NativeTooltipOverlayType.tooltip;
      if (useNativeOverlay) {
        _platform.showElementTooltip(
          anchor: buildElementTag(node: node, screenName: screenName),
          message: campaign.message,
          overlayType: campaign.overlayType,
        );
        // Hold the node so the overlay can follow it - see [notifyScrolled].
        // The node keeps a live Element reference, so re-measuring it later
        // reads the element's current position rather than a cached rect.
        if (_isFollowable(campaign.overlayType)) {
          _followedNode = node;
          _followedOverlayType = campaign.overlayType;
          _lastReportedBounds = node.bounds;
        }
      } else {
        _showPlatformViewTooltip(node, pixelRatio, campaign.message);
      }
    }
    _showCoachMarksFor(screenName, root);
  }

  /// Resolves every step of any coach mark campaign for [screenName] and shows
  /// them together.
  ///
  /// Steps whose element isn't mounted are dropped rather than failing the whole
  /// tour, so a partially-built screen still shows what it can. Nothing is sent
  /// when none resolved.
  void _showCoachMarksFor(String screenName, Element root) {
    final double pixelRatio = _pixelRatio;
    for (final _CoachMarkCampaign campaign in _coachMarkCampaigns) {
      if (campaign.screenName != screenName) continue;
      final List<Map<String, dynamic>> resolved = <Map<String, dynamic>>[];
      for (final _CoachMarkStepSpec step in campaign.steps) {
        final ElementNode? node =
            ElementInspector.findByNodeId(root, step.nodeId, pixelRatio);
        if (node == null) {
          debugPrint(
            'MoETooltipController: coach mark step "${step.nodeId}" not '
            'mounted on screen "$screenName" - dropping that step.',
          );
          continue;
        }
        resolved.add(MoECoachMarkStep(
          nodeId: step.nodeId,
          text: step.text,
          bounds: DesignModeElementBounds(
            top: node.bounds.top.round(),
            left: node.bounds.left.round(),
            bottom: node.bounds.bottom.round(),
            right: node.bounds.right.round(),
          ),
          cutoutCornerRadius: step.cutoutCornerRadius,
        ).toMap());
      }
      if (resolved.isEmpty) {
        debugPrint('MoETooltipController: no coach mark step resolved on '
            '"$screenName" - nothing shown.');
        continue;
      }
      _platform.showElementCoachMarks(steps: resolved);
      _coachMarksShowing = true;
    }
  }

  /// Whether [type]'s native overlay can be moved after it is shown.
  ///
  /// The tooltip and the beacon each have a re-anchor entry point. A spotlight
  /// captures its cutout once, and a coach mark places several cutouts and cards
  /// together - native has no API to move either.
  bool _isFollowable(NativeTooltipOverlayType type) =>
      type == NativeTooltipOverlayType.tooltip ||
      type == NativeTooltipOverlayType.beacon;

  /// Re-measures the followed anchor element and moves the native tooltip when
  /// it has actually shifted. Called by [MoEDesignModeWrapper]'s scroll
  /// listener.
  ///
  /// Native cannot do this itself: its own scroll-follow tracks a live
  /// `UIView`/`View`, and a Flutter widget has neither - only Dart can tell that
  /// the element moved.
  ///
  /// Deliberately not debounced. A timer would leave the card visibly lagging
  /// behind the finger mid-drag, and the work here is one `localToGlobal` on a
  /// single known element plus a channel message only when the rect changed.
  void notifyScrolled() {
    final ElementNode? node = _followedNode;
    if (node == null) return;

    final Rect? bounds = ElementInspector.refreshBounds(node, _pixelRatio);
    // Unmounted - a lazy list disposed the row after it scrolled past the cache
    // extent. The anchor genuinely no longer exists, so the overlay would be
    // pointing at nothing.
    if (bounds == null) {
      dismiss();
      return;
    }
    if (bounds == _lastReportedBounds) return;
    _lastReportedBounds = bounds;
    node.bounds = bounds;

    _platform.updateElementTooltipAnchor(
      bounds: DesignModeElementBounds(
        top: bounds.top.round(),
        left: bounds.left.round(),
        bottom: bounds.bottom.round(),
        right: bounds.right.round(),
      ),
      nodeId: node.nodeId,
      overlayType: _followedOverlayType,
    );
  }

  void _showPlatformViewTooltip(
    ElementNode node,
    double pixelRatio,
    String message,
  ) {
    final Rect logicalRect = Rect.fromLTRB(
      node.bounds.left / pixelRatio,
      node.bounds.top / pixelRatio,
      node.bounds.right / pixelRatio,
      node.bounds.bottom / pixelRatio,
    );
    current = VisibleTooltip(anchorRect: logicalRect, message: message);
    notifyListeners();
    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(_autoDismissDelay, dismiss);
  }

  /// Hides the currently-visible tooltip, if any, regardless of [renderMode]
  /// - called whenever the active screen changes so a tooltip never outlives
  /// the screen it was anchored to.
  void dismiss() {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
    // Stop following first: nothing is on screen to move any more, and leaving
    // the node set would keep every later scroll re-reporting bounds for a
    // tooltip that is gone.
    _followedNode = null;
    _lastReportedBounds = null;
    _platform.dismissElementTooltip();
    // Coach marks live in their own native overlay window, so the tooltip
    // dismiss above doesn't touch them.
    if (_coachMarksShowing) {
      _coachMarksShowing = false;
      _platform.dismissElementCoachMarks();
    }
    if (current == null) return;
    current = null;
    notifyListeners();
  }

  double get _pixelRatio {
    try {
      return PlatformDispatcher.instance.views.first.devicePixelRatio;
    } catch (_) {
      return 1.0;
    }
  }
}
