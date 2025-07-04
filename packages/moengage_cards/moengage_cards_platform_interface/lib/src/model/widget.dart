import 'package:moengage_flutter/moengage_flutter.dart' show AccessibilityData, keyAccessibility;
import '../internal/constants.dart';
import '../internal/payload_mapper.dart';
import 'action/action.dart';
import 'enums/widget_type.dart';
import 'style/widget_style.dart';

/// UI element in a card.
class Widget {
  /// [Widget] Constructor
  Widget({
    required this.id,
    required this.widgetType,
    required this.content,
    required this.style,
    required this.actionList,
    this.accessibilityData,
  });

  /// Get [Widget] from Json [Map]
  factory Widget.fromJson(Map<String, dynamic> json) {
    final WidgetType widgetType =
        WidgetType.values.byName(json[keyWidgetType].toString().toLowerCase());
    return Widget(
      id: (json[keyWidgetId] ?? -1) as int,
      widgetType: widgetType,
      content: (json[keyWidgetContent] ?? '') as String,
      style: widgetStyleFromJson(
        (json[keyWidgetStyle] ?? <String, dynamic>{}) as Map<String, dynamic>,
        widgetType,
      ),
      actionList: (json[keyActions] as Iterable)
          .map(
            (action) => actionStyleFromJson(action as Map<String, dynamic>),
          )
          .toList(),
      accessibilityData: json.containsKey(keyAccessibility) && json[keyAccessibility] != null
          ? AccessibilityData.fromJson(json[keyAccessibility] as Map<String, dynamic>)
          : null);
  }

  /// Identifier for the widget.
  int id;

  /// Type of widget
  WidgetType widgetType;

  /// Content to be loaded in the widget.
  String content;

  /// Style associated with the widget
  WidgetStyle? style;

  /// Actions to be performed on widget click
  List<Action> actionList;

  /// Accessibility information for the widget.
  AccessibilityData? accessibilityData;

  /// Convert [Widget] to Json [Map]
  Map<String, dynamic> toJson() => {
        keyWidgetId: id,
        keyWidgetContent: content,
        keyWidgetType: widgetType.name,
        keyWidgetStyle: style?.toJson(),
        keyActions: actionList.map((Action e) => e.toJson()).toList(),
        keyAccessibility: accessibilityData?.toJson()
      };

  @override
  String toString() {
    return 'Widget{id: $id, widgetType: $widgetType, content: $content, style: $style, actionList: $actionList, accessibilityData: $accessibilityData}';
  }
}
