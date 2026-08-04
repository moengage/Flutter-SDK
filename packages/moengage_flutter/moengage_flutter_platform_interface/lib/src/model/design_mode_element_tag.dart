import 'dart:convert';

import '../internal/constants.dart';
import '../internal/logger.dart';

/// Physical-pixel bounds of a picked element, relative to the screen origin.
class DesignModeElementBounds {
  /// [DesignModeElementBounds] Constructor
  DesignModeElementBounds({
    required this.top,
    required this.left,
    required this.bottom,
    required this.right,
  });

  /// Top edge, in physical pixels.
  final int top;

  /// Left edge, in physical pixels.
  final int left;

  /// Bottom edge, in physical pixels.
  final int bottom;

  /// Right edge, in physical pixels.
  final int right;

  /// Converts this instance to a JSON-serializable [Map].
  Map<String, dynamic> toMap() => <String, dynamic>{
        keyBoundsTop: top,
        keyBoundsLeft: left,
        keyBoundsBottom: bottom,
        keyBoundsRight: right,
      };
}

/// Result of a Design Mode element pick.
///
/// Identifies a single mounted Flutter [Element] chosen via the Design Mode
/// boom-menu picker: its stable identity ([nodeId]), its bounds on screen, and
/// the breadcrumb of ancestor identities ([ancestors]) leading up to it. This
/// is the payload sent to the native SDK so a tooltip/spotlight can later be
/// re-anchored to the same element (e.g. after scrolling or navigating back
/// to the screen).
class DesignModeElementTag {
  /// [DesignModeElementTag] Constructor
  DesignModeElementTag({
    required this.nodeId,
    required this.widgetType,
    required this.path,
    required this.screenName,
    required this.bounds,
    this.ancestors = const <String>[],
    this.paused = false,
  });

  /// Stable identity of the selected element: the widget's `ValueKey<String>`
  /// value if present, otherwise a structural path fallback (e.g.
  /// `/MaterialApp[0]/Scaffold[1]/Column[2]/ElevatedButton[3]`).
  final String nodeId;

  /// Simple runtime type name of the selected widget, e.g. `ElevatedButton`.
  final String widgetType;

  /// Structural path from the root to the selected element.
  final String path;

  /// Name of the screen (route) the element was picked on.
  final String screenName;

  /// Bounds of the selected element in physical pixels.
  final DesignModeElementBounds bounds;

  /// Node ids of ancestor elements from the immediate parent up to the root,
  /// used by native to disambiguate/re-locate the element.
  final List<String> ancestors;

  /// Whether the picker was paused (highlighted but not yet confirmed) when
  /// this tag was captured.
  final bool paused;

  /// Converts this instance to a JSON-serializable [Map] matching the
  /// payload expected by the native method channel handler.
  Map<String, dynamic> toMap() => <String, dynamic>{
        keyNodeId: nodeId,
        keyWidgetType: widgetType,
        keyPath: path,
        keyScreenName: screenName,
        keyBounds: bounds.toMap(),
        keyAncestors: ancestors,
        keyPaused: paused,
      };

  @override
  String toString() =>
      'DesignModeElementTag(nodeId: $nodeId, widgetType: $widgetType, '
      'path: $path, screenName: $screenName)';
}

/// Parses a [DesignModeElementTag] from a native callback payload.
DesignModeElementTag? designModeElementTagFromJson(dynamic methodCallArgs) {
  try {
    final Map<String, dynamic> payload =
        json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
    final Map<String, dynamic> boundsPayload =
        payload[keyBounds] as Map<String, dynamic>;
    return DesignModeElementTag(
      nodeId: payload[keyNodeId].toString(),
      widgetType: payload[keyWidgetType]?.toString() ?? '',
      path: payload[keyPath]?.toString() ?? '',
      screenName: payload[keyScreenName]?.toString() ?? '',
      bounds: DesignModeElementBounds(
        top: (boundsPayload[keyBoundsTop] as num).toInt(),
        left: (boundsPayload[keyBoundsLeft] as num).toInt(),
        bottom: (boundsPayload[keyBoundsBottom] as num).toInt(),
        right: (boundsPayload[keyBoundsRight] as num).toInt(),
      ),
      ancestors: (payload[keyAncestors] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          const <String>[],
      paused: payload[keyPaused] == true,
    );
  } catch (exception, stackTrace) {
    Logger.e('Core_ Error: designModeElementTagFromJson() : ',
        error: exception, stackTrace: stackTrace);
  }
  return null;
}
