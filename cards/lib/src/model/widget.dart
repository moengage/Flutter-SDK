import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/widget_style.dart';
import 'package:moengage_cards/src/model/widget_type.dart';

import '../internal/payload_mapper.dart';
import 'action.dart';

/// UI element in a card.
class Widget {
  /// Identifier for the widget.
  int id;

  /// Type of widget
  WidgetType widgetType;

  /// Content to be loaded in the widget.
  String content;

  /// Style associated with the widget
  WidgetStyle style;

  /// Actions to be performed on widget click
  List<Action> actionList;

  Widget(
      {required this.id,
      required this.widgetType,
      required this.content,
      required this.style,
      required this.actionList});

  factory Widget.fromJson(Map<String, dynamic> json) {
    final widgetType =
        WidgetType.values.byName(json[keyWidgetType].toString().toLowerCase());
    return Widget(
        id: json[keyWidgetId],
        widgetType: widgetType,
        content: json[keyWidgetContent],
        style: widgetStyleFromJson(json[keyWidgetStyle], widgetType),
        actionList: (json[keyActions] as Iterable)
            .map(
                (action) => actionStyleFromJson(action as Map<String, dynamic>))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        keyWidgetId: id,
        keyWidgetContent: content,
        keyWidgetType: widgetType.name,
        keyWidgetStyle: style.toJson(),
        keyActions: actionList.map((e) => e.toJson()).toList()
      };
}
