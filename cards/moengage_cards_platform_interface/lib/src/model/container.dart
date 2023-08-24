import '../internal/constants.dart';
import '../internal/payload_mapper.dart';
import 'action/action.dart';
import 'enums/template_type.dart';
import 'style/container_style.dart';
import 'widget.dart';

/// Container to hold UI widget. Equivalent to a Container Widget in Flutter
class Container {
  /// [Container] Constructor
  Container({
    required this.id,
    required this.templateType,
    required this.style,
    required this.widgets,
    required this.actionList,
  });

  /// Get [Container] from Json [Map]
  factory Container.fromJson(Map<String, dynamic> json) {
    return Container(
      id: (json[keyContainerId]) as int,
      templateType:
          TemplateType.values.byName(json[keyContainerType] as String),
      widgets: ((json[keyWidgets] ?? []) as List)
          .map((e) => Widget.fromJson(e as Map<String, dynamic>))
          .toList(),
      actionList: ((json[keyActions] ?? []) as List)
          .map((e) => actionStyleFromJson(e as Map<String, dynamic>))
          .toList(),
      style: (json[keyContainerStyle] != null)
          ? ContainerStyle.fromJson(
              (json[keyContainerStyle]) as Map<String, dynamic>,
            )
          : null,
    );
  }

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

  /// Convert [Container] to Json [Map]
  Map<String, dynamic> toJson() => {
        keyContainerId: id,
        keyTemplateType: templateType.name,
        keyContainerStyle: style?.toJson(),
        keyWidgets: widgets.map((Widget e) => e.toJson()).toList(),
        keyActions: actionList.map((Action e) => e.toJson()).toList()
      };
}
