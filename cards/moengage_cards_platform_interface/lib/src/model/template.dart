import '../internal/constants.dart';
import 'container.dart';
import 'enums/template_type.dart';

/// Card Template data.
class Template {
  Template({
    required this.templateType,
    required this.containers,
    required this.kvPairs,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      templateType: TemplateType.values.byName(json[keyTemplateType] as String),
      containers: List<Container>.from(
        ((json[keyContainers] ?? []) as Iterable).map(
          (dataJson) => Container.fromJson(dataJson as Map<String, dynamic>),
        ),
      ),
      kvPairs: (json[keyKVPairs] ?? {}) as Map<String, dynamic>,
    );
  }

  /// Type of Template
  TemplateType templateType;

  /// Containers in the template.
  List<Container> containers;

  /// Additional data associated to the template
  Map<String, dynamic> kvPairs;

  Map<String, dynamic> toJson() => {
        keyTemplateType: templateType.name,
        keyContainers: containers.map((Container e) => e.toJson()).toList(),
        keyKVPairs: kvPairs
      };
}
