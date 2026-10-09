import 'user_attribute_level.dart';

/// What was removed by a successful [unsetUserAttribute] call, echoed back so a caller running
/// several unsets can tell the results apart.
class UnsetUserAttributeResult {
  /// [UnsetUserAttributeResult] Constructor
  UnsetUserAttributeResult({
    required this.attributeName,
    required this.attributeLevel,
  });

  /// Name of the attribute that was removed.
  final String attributeName;

  /// Level the attribute was removed from.
  final UserAttributeLevel attributeLevel;

  @override
  String toString() {
    return 'UnsetUserAttributeResult{attributeName: $attributeName, '
        'attributeLevel: $attributeLevel}';
  }
}
