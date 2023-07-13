import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/container.dart';
import 'package:moengage_cards/src/model/enums/template_type.dart';

/// Card Template data.
class Template {
  /// Type of Template
  TemplateType templateType;

  /// Containers in the template.
  List<Container> containers;

  /// Additional data associated to the template
  Map<String, dynamic> kvPairs;

  Template(
      {required this.templateType,
      required this.containers,
      required this.kvPairs});

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
        templateType: TemplateType.values.byName(json[keyTemplateType]),
        containers: List<Container>.from(
            ((json[keyContainers] ?? []) as Iterable)
                .map((dataJson) => Container.fromJson(dataJson))),
        kvPairs: json[keyKVPairs] ?? {});
  }

  Map<String, dynamic> toJson() => {
        keyTemplateType: templateType.name,
        keyContainers: containers.map((e) => e.toJson()).toList(),
        keyKVPairs: kvPairs
      };
}
