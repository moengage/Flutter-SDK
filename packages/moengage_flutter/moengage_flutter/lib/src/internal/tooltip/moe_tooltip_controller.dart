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
      overlayType: NativeTooltipOverlayType.beacon,
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
      switch (renderMode) {
        case TooltipRenderMode.nativeOverlay:
          _platform.showElementTooltip(
            anchor: buildElementTag(node: node, screenName: screenName),
            message: campaign.message,
            overlayType: campaign.overlayType,
          );
          break;
        case TooltipRenderMode.platformView:
          _showPlatformViewTooltip(node, pixelRatio, campaign.message);
          break;
      }
    }
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
    _platform.dismissElementTooltip();
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
