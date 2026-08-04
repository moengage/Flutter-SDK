import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

import 'element_inspector.dart';
import 'element_node.dart';
import 'element_tag_builder.dart';

/// Lifecycle state of the Design Mode element picker.
enum DesignModePickerState {
  /// Picker overlay isn't shown.
  inactive,

  /// Overlay is shown; tapping the screen (re-)hit-tests and highlights an
  /// element under the boom menu.
  picking,

  /// An element is highlighted and the picker is intentionally frozen
  /// (e.g. so the marketer can scroll without losing the current pick).
  paused,
}

/// Drives the Design Mode element picker: hit-testing taps against the live
/// widget tree, tracking the currently highlighted [ElementNode], and
/// reporting a confirmed selection to native. A single app-wide instance is
/// used since only one Design Mode session can be active at a time.
class DesignModeController extends ChangeNotifier {
  /// Factory Constructor
  factory DesignModeController.instance() => _instance;

  DesignModeController._internal();

  static final DesignModeController _instance =
      DesignModeController._internal();

  MoEngageFlutterPlatform get _platform => MoEngageFlutterPlatform.instance;

  Element? _root;
  String _screenName = '';
  Timer? _scrollThrottle;

  /// Current lifecycle state.
  DesignModePickerState state = DesignModePickerState.inactive;

  /// Currently highlighted/selected element, if any.
  ElementNode? current;

  bool get _isActive => state != DesignModePickerState.inactive;

  /// Registers the root [Element] the picker should hit-test under. Called
  /// by the wrapper widget after every frame so it always reflects the live
  /// tree (the [Element] itself is stable across rebuilds as long as the
  /// wrapper's position in the tree doesn't change).
  void attach(Element root) {
    _root = root;
  }

  /// Updates the tracked screen name, e.g. from a [NavigatorObserver].
  void updateScreenName(String screenName) {
    _screenName = screenName;
  }

  /// Activates the picker. No-op if already active.
  void activate() {
    if (_isActive) return;
    state = DesignModePickerState.picking;
    current = null;
    _platform.activateDesignMode();
    notifyListeners();
  }

  /// Deactivates the picker and clears any in-progress selection.
  void deactivate() {
    if (!_isActive) return;
    state = DesignModePickerState.inactive;
    current = null;
    _scrollThrottle?.cancel();
    _platform.deactivateDesignMode();
    notifyListeners();
  }

  /// Hit-tests [globalPosition] (logical pixels) against the live tree and
  /// highlights the deepest element found, if any. No-op unless
  /// [DesignModePickerState.picking].
  void selectAt(Offset globalPosition) {
    if (state != DesignModePickerState.picking) return;
    final Element? root = _root;
    if (root == null) return;
    final ElementNode? node =
        ElementInspector.hitTest(root, globalPosition, _pixelRatio);
    if (node != null) {
      current = node;
      _logSelectedNode(node);
      notifyListeners();
    }
  }

  /// Logs the widget/node picked so it can be inspected from the console.
  void _logSelectedNode(ElementNode node) {
    debugPrint(
      'MoEDesignMode: selected widgetType=${node.widgetType} '
      'nodeId=${node.nodeId} path=${cleanElementPath(node.path)} '
      'screenName=$_screenName bounds=${node.bounds} '
      'ancestors=${node.ancestors.map((ElementNode a) => a.widgetType).toList()}',
    );
  }

  /// Freezes the current highlight so it survives scrolling/interaction
  /// without being replaced by the next tap. No-op if nothing is selected.
  void pause() {
    if (current == null) return;
    state = DesignModePickerState.paused;
    notifyListeners();
  }

  /// Resumes picking, allowing further taps to re-hit-test.
  void resume() {
    if (state == DesignModePickerState.inactive) return;
    state = DesignModePickerState.picking;
    notifyListeners();
  }

  /// Replaces the current selection with its nearest resolvable ancestor,
  /// e.g. when a tap landed on a `Text` but the marketer meant its parent
  /// `ElevatedButton`.
  void navigateToParent() {
    final ElementNode? node = current;
    if (node == null || node.ancestors.isEmpty) return;
    current = node.ancestors.first;
    notifyListeners();
  }

  /// Replaces the current selection with its first descendant that owns a
  /// laid-out [RenderBox], for drilling back down after [navigateToParent].
  void navigateToChild() {
    final ElementNode? node = current;
    if (node == null) return;
    final ElementNode? child =
        ElementInspector.firstRenderedDescendant(node, _pixelRatio);
    if (child != null) {
      current = child;
      notifyListeners();
    }
  }

  /// Scrolls the current selection's nearest [Scrollable] ancestor so the
  /// element is fully on-screen, then refreshes its bounds.
  Future<void> findInScroll() async {
    final ElementNode? node = current;
    if (node == null || !node.isMounted) return;
    try {
      await Scrollable.ensureVisible(
        node.element,
        duration: const Duration(milliseconds: 300),
      );
    } catch (_) {
      // No enclosing Scrollable, or it couldn't be scrolled - ignore.
    }
    refreshCurrentBounds();
  }

  /// Re-resolves the current selection's bounds in place. Called on a
  /// throttled scroll notification so the highlight tracks the element
  /// instead of drifting away from it.
  void refreshCurrentBounds() {
    final ElementNode? node = current;
    if (node == null) return;
    final Rect? bounds = ElementInspector.refreshBounds(node, _pixelRatio);
    if (bounds == null) {
      // Element was unmounted (scrolled far enough to be disposed).
      current = null;
      notifyListeners();
      return;
    }
    node.bounds = bounds;
    notifyListeners();
  }

  /// Throttled entry point for scroll notifications from the wrapper widget.
  void notifyScrolled() {
    if (state == DesignModePickerState.inactive || current == null) return;
    _scrollThrottle?.cancel();
    _scrollThrottle = Timer(
      const Duration(milliseconds: 250),
      refreshCurrentBounds,
    );
  }

  /// Confirms the current selection, reporting it to native. Deactivates the
  /// picker afterwards unless [keepPicking] is set, allowing a marketer to
  /// tag multiple elements in one session.
  void confirmSelection({bool keepPicking = false}) {
    final ElementNode? node = current;
    if (node == null) return;
    final DesignModeElementTag tag = buildElementTag(
      node: node,
      screenName: _screenName,
      paused: state == DesignModePickerState.paused,
    );
    _platform.reportDesignModeElementSelected(tag);
    if (keepPicking) {
      current = null;
      state = DesignModePickerState.picking;
      notifyListeners();
    } else {
      deactivate();
    }
  }

  /// Clears the current selection and resumes picking without confirming.
  void cancelSelection() {
    current = null;
    if (_isActive) state = DesignModePickerState.picking;
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
