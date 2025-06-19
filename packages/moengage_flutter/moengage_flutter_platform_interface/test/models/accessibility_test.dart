import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

void main() {
  group('Accessibility', () {
    test('should create Accessibility with non-null text and hint', () {
      final accessibility = AccessibilityData('Accessible text', 'A hint');
      expect(accessibility.text, equals('Accessible text'));
      expect(accessibility.hint, equals('A hint'));
    });

    test('should create Accessibility with a non-null text and null hint', () {
      final accessibility = AccessibilityData('Accessible text', null);
      expect(accessibility.text, equals('Accessible text'));
      expect(accessibility.hint, isNull);
    });

    test('toString returns the expected string representation', () {
      final accessibility = AccessibilityData('Text value', 'Hint value');
      expect(
        accessibility.toString(),
        equals('AccessibilityData(text: Text value, hint: Hint value)'),
      );
    });

    test('fromJson returns expected Accessibility with non-null values', () {
      final json = <String, dynamic>{
        keyAccessibilityText: 'From JSON text',
        keyAccessibilityHint: 'From JSON hint',
      };
      final accessibility = AccessibilityData.fromJson(json);
      expect(accessibility.text, equals('From JSON text'));
      expect(accessibility.hint, equals('From JSON hint'));
    });

    test('toJson returns expected Map with non-null values', () {
      final accessibility = AccessibilityData('ToJson text', 'ToJson hint');
      final json = accessibility.toJson();
      expect(json[keyAccessibilityText], equals('ToJson text'));
      expect(json[keyAccessibilityHint], equals('ToJson hint'));
    });

    test('fromJson returns expected Accessibility with null values', () {
      final json = <String, dynamic>{
        keyAccessibilityText: null,
        keyAccessibilityHint: null,
      };
      final accessibility = AccessibilityData.fromJson(json);
      expect(accessibility.text, isNull);
      expect(accessibility.hint, isNull);
    });
  });
}