import '../../internal/constants.dart';

/// Accessibility Data UI Component
class AccessibilityData {

  /// [AccessibilityData] Constructor
AccessibilityData(this.text, this.hint);

/// Creates an [AccessibilityData] instance from a JSON [Map]
  factory AccessibilityData.fromJson(Map<String, dynamic> json) {
    return AccessibilityData(
      json[keyAccessibilityText] as String?,
      json[keyAccessibilityHint] as String?,
    );
  }
  /// Text for the AccessibilityData
  String? text;

  /// Hint for the AccessibilityData. Applicable only for iOS Platform
  String? hint;

  @override
  String toString() {
    return 'AccessibilityData(text: $text, hint: $hint)';
  }
   /// Converts the [AccessibilityData] instance to a JSON [Map]
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      keyAccessibilityText: text,
      keyAccessibilityHint: hint,
    };
  }
}
