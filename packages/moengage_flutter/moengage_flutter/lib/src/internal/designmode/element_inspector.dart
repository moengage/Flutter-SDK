import 'package:flutter/widgets.dart';

import 'element_node.dart';

/// Walks the live Flutter [Element] tree to resolve elements for the Design
/// Mode picker: hit-testing a tap to the deepest element under it, and
/// re-resolving a previously picked element's bounds (e.g. after a scroll).
///
/// Unlike a full tree dump (Apxor-style), this only visits elements that own
/// a [RenderBox] so bounds are meaningful; every such element gets a stable
/// [ElementNode.nodeId] derived from its `ValueKey<String>` if the app
/// developer set one, otherwise from a structural path (widget type + sibling
/// occurrence index), so native can request the element again after a
/// rebuild even without a developer-assigned key.
class ElementInspector {
  /// Finds the deepest mounted element under [globalPosition] (logical
  /// pixels), starting the walk from [root]. Returns `null` if nothing with a
  /// laid-out [RenderBox] contains the position.
  static ElementNode? hitTest(
    Element root,
    Offset globalPosition,
    double pixelRatio,
  ) {
    ElementNode? best;
    final List<ElementNode> ancestorStack = <ElementNode>[];

    void visit(Element element, String path) {
      bool pushed = false;
      final RenderObject? renderObject = element.renderObject;
      if (renderObject is RenderBox &&
          renderObject.attached &&
          renderObject.hasSize) {
        final Offset? origin = _globalOriginOf(element, renderObject);
        if (origin != null) {
          final Rect logicalRect = origin & renderObject.size;
          if (logicalRect.contains(globalPosition)) {
            final ElementNode node = ElementNode(
              element: element,
              nodeId: _nodeIdFor(element, path),
              widgetType: element.widget.runtimeType.toString(),
              path: path,
              bounds: _toPhysicalRect(logicalRect, pixelRatio),
              ancestors: List<ElementNode>.from(ancestorStack.reversed),
            );
            best = node;
            ancestorStack.add(node);
            pushed = true;
          }
        }
      }
      final Map<String, int> childOccurrence = <String, int>{};
      element.visitChildren((Element child) {
        final String typeName = child.widget.runtimeType.toString();
        final int index = childOccurrence.update(
          typeName,
          (int v) => v + 1,
          ifAbsent: () => 0,
        );
        visit(child, '$path/$typeName[$index]');
      });
      if (pushed) ancestorStack.removeLast();
    }

    final Map<String, int> rootOccurrence = <String, int>{};
    root.visitChildren((Element child) {
      final String typeName = child.widget.runtimeType.toString();
      final int index = rootOccurrence.update(
        typeName,
        (int v) => v + 1,
        ifAbsent: () => 0,
      );
      visit(child, '/$typeName[$index]');
    });
    return best;
  }

  /// Finds the first descendant of [parent] (in tree order) that owns a
  /// laid-out [RenderBox], for boom-menu "select child" navigation. Returns
  /// `null` if [parent] has no such descendant (it's a leaf).
  static ElementNode? firstRenderedDescendant(
    ElementNode parent,
    double pixelRatio,
  ) {
    ElementNode? found;
    final Map<String, int> childOccurrence = <String, int>{};

    void visit(Element element, String path) {
      if (found != null) return;
      final RenderObject? renderObject = element.renderObject;
      if (renderObject is RenderBox &&
          renderObject.attached &&
          renderObject.hasSize) {
        final Offset? origin = _globalOriginOf(element, renderObject);
        if (origin != null) {
          found = ElementNode(
            element: element,
            nodeId: _nodeIdFor(element, path),
            widgetType: element.widget.runtimeType.toString(),
            path: path,
            bounds: _toPhysicalRect(origin & renderObject.size, pixelRatio),
            ancestors: <ElementNode>[parent, ...parent.ancestors],
          );
          return;
        }
      }
      element.visitChildren((Element child) {
        if (found != null) return;
        final String typeName = child.widget.runtimeType.toString();
        final int index = childOccurrence.update(
          typeName,
          (int v) => v + 1,
          ifAbsent: () => 0,
        );
        visit(child, '$path/$typeName[$index]');
      });
    }

    parent.element.visitChildren((Element child) {
      if (found != null) return;
      final String typeName = child.widget.runtimeType.toString();
      final int index = childOccurrence.update(
        typeName,
        (int v) => v + 1,
        ifAbsent: () => 0,
      );
      visit(child, '${parent.path}/$typeName[$index]');
    });
    return found;
  }

  /// Searches the whole live tree from [root] for the mounted element whose
  /// resolved node id equals [nodeId] (see [_nodeIdFor]), e.g. to re-anchor a
  /// tooltip to a widget identified by a hardcoded/backend campaign rather
  /// than by a tap position. Returns `null` if no such element is currently
  /// mounted (e.g. the screen hasn't built it yet).
  static ElementNode? findByNodeId(
    Element root,
    String nodeId,
    double pixelRatio,
  ) {
    ElementNode? found;

    void visit(Element element, String path) {
      if (found != null) return;
      final RenderObject? renderObject = element.renderObject;
      if (renderObject is RenderBox &&
          renderObject.attached &&
          renderObject.hasSize &&
          _nodeIdFor(element, path) == nodeId) {
        final Offset? origin = _globalOriginOf(element, renderObject);
        if (origin != null) {
          found = ElementNode(
            element: element,
            nodeId: nodeId,
            widgetType: element.widget.runtimeType.toString(),
            path: path,
            bounds: _toPhysicalRect(origin & renderObject.size, pixelRatio),
            ancestors: const <ElementNode>[],
          );
          return;
        }
      }
      final Map<String, int> childOccurrence = <String, int>{};
      element.visitChildren((Element child) {
        if (found != null) return;
        final String typeName = child.widget.runtimeType.toString();
        final int index = childOccurrence.update(
          typeName,
          (int v) => v + 1,
          ifAbsent: () => 0,
        );
        visit(child, '$path/$typeName[$index]');
      });
    }

    final Map<String, int> rootOccurrence = <String, int>{};
    root.visitChildren((Element child) {
      if (found != null) return;
      final String typeName = child.widget.runtimeType.toString();
      final int index = rootOccurrence.update(
        typeName,
        (int v) => v + 1,
        ifAbsent: () => 0,
      );
      visit(child, '/$typeName[$index]');
    });
    return found;
  }

  /// Re-resolves [node]'s bounds from its still-live [Element]. Returns
  /// `null` if the element was unmounted (e.g. scrolled out and disposed) or
  /// no longer has a laid-out [RenderBox].
  static Rect? refreshBounds(ElementNode node, double pixelRatio) {
    if (!node.isMounted) return null;
    final RenderObject? renderObject = node.element.renderObject;
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return null;
    }
    final Offset? origin = _globalOriginOf(node.element, renderObject);
    if (origin == null) return null;
    return _toPhysicalRect(origin & renderObject.size, pixelRatio);
  }

  static Offset? _globalOriginOf(Element element, RenderBox renderBox) {
    try {
      // Anchor to the nearest Navigator so bounds inside a nested
      // Navigator (dialog, bottom sheet) are correct, matching the pattern
      // used by reference Flutter widget-position tools.
      final NavigatorState? navigator =
          element.findAncestorStateOfType<NavigatorState>();
      final RenderObject? ancestor = navigator?.context.findRenderObject();
      if (ancestor != null) {
        return renderBox.localToGlobal(Offset.zero, ancestor: ancestor);
      }
      return renderBox.localToGlobal(Offset.zero);
    } catch (_) {
      return null;
    }
  }

  static Rect _toPhysicalRect(Rect logicalRect, double pixelRatio) {
    return Rect.fromLTWH(
      logicalRect.left * pixelRatio,
      logicalRect.top * pixelRatio,
      logicalRect.width * pixelRatio,
      logicalRect.height * pixelRatio,
    );
  }

  static String _nodeIdFor(Element element, String structuralPath) {
    final Key? key = element.widget.key;
    if (key is ValueKey<String>) return key.value;
    return structuralPath;
  }
}
