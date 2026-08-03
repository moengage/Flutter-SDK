import '../internal/constants.dart';
// import other models/enums as needed

/// <ModelName> — derived from protos/<contractDir>/<ModelName>.proto
class <ModelName> {
  <ModelName>({required this.<requiredField>, this.<optionalField>});

  factory <ModelName>.fromJson(Map<String, dynamic> data) {
    return <ModelName>(
      <requiredField>: data[key<RequiredField>] as <Type>,
      <optionalField>: data[key<OptionalField>] as <Type>?,
      // nested model example:
      // nested: data[keyNested] != null
      //     ? <NestedModel>.fromJson(data[keyNested] as Map<String, dynamic>)
      //     : null,
    );
  }

  final <Type> <requiredField>;
  final <Type>? <optionalField>;

  Map<String, dynamic> toJson() => {
    key<RequiredField>: <requiredField>,
    if (<optionalField> != null) key<OptionalField>: <optionalField>,
  };

  @override
  String toString() => '<ModelName>{<requiredField>: $<requiredField>}';
}
