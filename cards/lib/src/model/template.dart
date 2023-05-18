import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/model/container.dart';
import 'package:moengage_cards/src/model/template_type.dart';

class Template {
  TemplateType templateType;
  List<Container> containers;
  Map<String, dynamic> kvPairs;

  Template(
      {required this.templateType,
      required this.containers,
      required this.kvPairs});

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
        templateType: TemplateType.values.byName(json[keyTemplateType]),
        containers: List<Container>.from((json[keyContainers] as Iterable)
            .map((dataJson) => Container.fromJson(dataJson))),
        kvPairs: json[keyKVPairs]);
  }

  Map<String, dynamic> toJson() => {
        keyTemplateType: templateType.name ?? "",
        keyContainers: containers.map((e) => e.toJson()).toList(),
        keyKVPairs: kvPairs
      };
}
