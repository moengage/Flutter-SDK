import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

import 'element_node.dart';

/// Runtime type names of Flutter-framework/plumbing widgets that don't
/// represent meaningful UI structure - focus/gesture/scroll/animation wiring,
/// route transition machinery, etc. Stripped from reported paths and
/// ancestor chains so the tree sent to native (and onward to the backend)
/// reflects the app's actual UI instead of framework internals.
const Set<String> _noiseWidgetTypes = <String>{
  'FocusScope',
  'Semantics',
  'Focus',
  'FocusTraversalGroup',
  'NotificationListener',
  'Listener',
  'RawGestureDetector',
  'GestureDetector',
  'AbsorbPointer',
  'IgnorePointer',
  'MouseRegion',
  'Overlay',
  'TickerMode',
  'AnimatedBuilder',
  'ListenableBuilder',
  'RestorationScope',
  'UnmanagedRestorationScope',
  'PageStorage',
  'Actions',
  'Builder',
  'RepaintBoundary',
  'KeyedSubtree',
  'HeroControllerScope',
  'PrimaryScrollController',
  'ScrollNotificationObserver',
  'ScrollConfiguration',
  'DualTransitionBuilder',
  'SnapshotWidget',
  'CustomMultiChildLayout',
  'LayoutId',
  'MediaQuery',
  'DefaultSelectionStyle',
  'DefaultTextStyle',
  'AnimatedDefaultTextStyle',
  'AnimatedPhysicalModel',
  'PhysicalModel',
  'Material',
  'Ink',
  'ClipRect',
  'Transform',
  'StretchingOverscrollIndicator',
  'Viewport',
  'SliverPadding',
  'AutomaticKeepAlive',
  'KeepAlive',
  'IndexedSemantics',
  'DecoratedBox',
};

bool _isNoise(String widgetType) =>
    widgetType.startsWith('_') || _noiseWidgetTypes.contains(widgetType);

/// Strips noise segments from a raw structural path produced by
/// `ElementInspector` (e.g.
/// `/FocusScope[0]/Semantics[0]/.../ListTile[3]/RichText[0]`), so the path
/// reported outward reflects the app's actual widget tree rather than
/// Flutter's internal plumbing.
String cleanElementPath(String rawPath) {
  final List<String> cleaned = <String>[];
  for (final String segment in rawPath.split('/')) {
    if (segment.isEmpty) continue;
    final int bracketIndex = segment.indexOf('[');
    final String typeName =
        bracketIndex == -1 ? segment : segment.substring(0, bracketIndex);
    if (_isNoise(typeName)) continue;
    cleaned.add(segment);
  }
  return cleaned.isEmpty ? rawPath : '/${cleaned.join('/')}';
}

String _cleanNodeId(String nodeId) =>
    nodeId.startsWith('/') ? cleanElementPath(nodeId) : nodeId;

/// Builds a [DesignModeElementTag] for [node], cleaning its structural path
/// and ancestor chain of Flutter-internal plumbing widgets before it's
/// reported to native. Developer-assigned `ValueKey<String>` node ids are
/// passed through unchanged since they're already meaningful.
DesignModeElementTag buildElementTag({
  required ElementNode node,
  required String screenName,
  bool paused = false,
}) {
  return DesignModeElementTag(
    nodeId: _cleanNodeId(node.nodeId),
    widgetType: node.widgetType,
    path: cleanElementPath(node.path),
    screenName: screenName,
    bounds: DesignModeElementBounds(
      top: node.bounds.top.round(),
      left: node.bounds.left.round(),
      bottom: node.bounds.bottom.round(),
      right: node.bounds.right.round(),
    ),
    ancestors: node.ancestors
        .where((ElementNode ancestor) => !_isNoise(ancestor.widgetType))
        .map((ElementNode ancestor) => _cleanNodeId(ancestor.nodeId))
        .toList(),
    paused: paused,
  );
}
