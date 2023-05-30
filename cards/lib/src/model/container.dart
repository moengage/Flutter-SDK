import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/action/action.dart';
import 'package:moengage_cards/src/model/style/container_style.dart';
import 'package:moengage_cards/src/model/enums/template_type.dart';
import 'package:moengage_cards/src/model/widget.dart';
import 'package:moengage_cards/src/internal/payload_mapper.dart';

/// Container to hold UI widget. Equivalent to a Container Widget in Flutter
class Container {
  /// Unique identifier for a template
  final int id;

  /// Type of container
  final TemplateType templateType;

  /// Style associated to the Container
  final ContainerStyle? style;

  /// [List] of [Widget]
  final List<Widget> widgets;

  /// [List] of [Action] for the container
  final List<Action> actionList;

  Container(
      {required this.id,
      required this.templateType,
      required this.style,
      required this.widgets,
      required this.actionList});

  factory Container.fromJson(Map<String, dynamic> json) {
    return Container(
        id: json[keyContainerId],
        templateType: TemplateType.values.byName(json[keyContainerType]),
        widgets: ((json[keyWidgets] ?? []) as List)
            .map((e) => Widget.fromJson(e))
            .toList(),
        actionList: ((json[keyActions] ?? []) as List)
            .map((e) => actionStyleFromJson(e))
            .toList(),
        style: (json[keyContainerStyle] != null)
            ? ContainerStyle.fromJson(json[keyContainerStyle])
            : null);
  }

  Map<String, dynamic> toJson() => {
        keyContainerId: id,
        keyTemplateType: templateType.name,
        keyContainerStyle: style?.toJson(),
        keyWidgets: widgets.map((e) => e.toJson()).toList(),
        keyActions: actionList.map((e) => e.toJson()).toList()
      };
}
