import 'package:flutter/widgets.dart';

/// A single mounted Flutter [Element] resolved by the Design Mode inspector,
/// carrying just enough data to highlight it, report it to native, and
/// re-locate it later (e.g. after a scroll or a rebuild).
class ElementNode {
  /// [ElementNode] Constructor
  ElementNode({
    required this.element,
    required this.nodeId,
    required this.widgetType,
    required this.path,
    required this.bounds,
    required this.ancestors,
  });

  /// The live [Element] this node wraps. Not sent over the platform channel;
  /// used only to re-resolve bounds (e.g. on scroll) or to navigate to a
  /// parent/child element while still mounted.
  final Element element;

  /// Stable identity: the widget's `ValueKey<String>` value if present,
  /// otherwise a structural path fallback.
  final String nodeId;

  /// Simple runtime type name of the widget, e.g. `ElevatedButton`.
  final String widgetType;

  /// Structural path from the root to this element.
  final String path;

  /// Bounds in physical pixels, relative to the screen origin. Mutable so a
  /// live pick can be repositioned in place after a scroll/layout change.
  Rect bounds;

  /// Resolved ancestor nodes, nearest parent first, root last. Only elements
  /// that themselves own a laid-out [RenderBox] are included, so this list
  /// doubles as the "navigate to parent" chain.
  final List<ElementNode> ancestors;

  /// Whether the underlying [Element] is still part of the tree.
  bool get isMounted => element.mounted;
}
