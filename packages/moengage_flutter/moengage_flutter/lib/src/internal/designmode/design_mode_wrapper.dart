import 'package:flutter/widgets.dart';

import '../tooltip/element_tooltip_overlay.dart';
import '../tooltip/moe_tooltip_controller.dart';
import 'design_mode_controller.dart';
import 'design_mode_overlay.dart';

/// Wraps the Flutter app so the Design Mode element picker can render its
/// boom-menu overlay above any screen and hit-test the live widget tree.
///
/// Add it via [MaterialApp.builder]/[CupertinoApp.builder] so it sits inside
/// the app's [Directionality]/[MediaQuery] but can still draw above the
/// routed content of every screen:
///
/// ```dart
/// MaterialApp(
///   navigatorObservers: [MoENavigationObserver()],
///   builder: (context, child) =>
///       MoEDesignModeWrapper(child: child ?? const SizedBox.shrink()),
///   home: const HomeScreen(),
/// )
/// ```
class MoEDesignModeWrapper extends StatefulWidget {
  /// [MoEDesignModeWrapper] Constructor
  const MoEDesignModeWrapper({required this.child, super.key});

  /// The app content (typically the `child` passed into `MaterialApp.builder`).
  final Widget child;

  @override
  State<MoEDesignModeWrapper> createState() => _MoEDesignModeWrapperState();
}

class _MoEDesignModeWrapperState extends State<MoEDesignModeWrapper> {
  final GlobalKey _contentKey = GlobalKey();
  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();
  OverlayEntry? _pickerEntry;
  OverlayEntry? _tooltipEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _insertPickerEntry();
      _insertTooltipEntry();
      _attachRoot();
    });
  }

  void _insertPickerEntry() {
    if (_pickerEntry != null) return;
    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext context) => const DesignModeOverlay(),
    );
    _pickerEntry = entry;
    _overlayKey.currentState?.insert(entry);
  }

  void _insertTooltipEntry() {
    if (_tooltipEntry != null) return;
    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext context) => const ElementTooltipOverlay(),
    );
    _tooltipEntry = entry;
    _overlayKey.currentState?.insert(entry);
  }

  void _attachRoot() {
    final BuildContext? context = _contentKey.currentContext;
    if (context == null) return;
    DesignModeController.instance().attach(context as Element);
    MoETooltipController.instance().attach(context);
  }

  /// Fires for a scroll anywhere in the app - Flutter bubbles
  /// [ScrollNotification] up the tree, so no per-list `ScrollController` is
  /// needed.
  ///
  /// Both listeners re-measure their own element: the picker moves its
  /// highlight, and a showing tooltip moves with its anchor. Returning `false`
  /// lets the notification keep bubbling to the app's own listeners.
  bool _onScrollNotification(ScrollNotification notification) {
    DesignModeController.instance().notifyScrolled();
    MoETooltipController.instance().notifyScrolled();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachRoot());
    return Overlay(
      key: _overlayKey,
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext context) =>
              NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: KeyedSubtree(key: _contentKey, child: widget.child),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pickerEntry?.remove();
    _tooltipEntry?.remove();
    super.dispose();
  }
}

/// Tracks the current screen name for the Design Mode picker so a confirmed
/// element selection is tagged with the route it was found on. Add this to
/// `MaterialApp(navigatorObservers: [...])`.
class MoENavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    MoETooltipController.instance().dismiss();
    _track(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    MoETooltipController.instance().dismiss();
    _track(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    MoETooltipController.instance().dismiss();
    _track(newRoute);
  }

  void _track(Route<dynamic>? route) {
    final String? name = route?.settings.name;
    if (name == null || name.isEmpty) return;
    DesignModeController.instance().updateScreenName(name);
    _checkTooltipWhenSettled(route!, name);
  }

  /// Resolves the tooltip anchor only after [route]'s transition animation
  /// has finished, instead of a single post-frame callback right after
  /// [didPush]/[didPop] - the pushed/revealed route can still be mid-transition
  /// at that point (e.g. Material 3's default zoom transition), so the
  /// anchor widget's layout isn't guaranteed to have settled yet.
  void _checkTooltipWhenSettled(Route<dynamic> route, String name) {
    final Animation<double>? animation =
        route is TransitionRoute<dynamic> ? route.animation : null;
    if (animation == null || animation.isCompleted || animation.isDismissed) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => MoETooltipController.instance().onScreenChanged(name),
      );
      return;
    }
    late final AnimationStatusListener listener;
    listener = (AnimationStatus status) {
      if (status != AnimationStatus.completed &&
          status != AnimationStatus.dismissed) {
        return;
      }
      animation.removeStatusListener(listener);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => MoETooltipController.instance().onScreenChanged(name),
      );
    };
    animation.addStatusListener(listener);
  }
}
