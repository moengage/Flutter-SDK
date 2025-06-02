import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_inbox_platform_interface/src/model/accessibility.dart';

void main() {
  group('Accessibility', () {
    test('should create Accessibility with a non-null text and hint', () {
      final accessibility = Accessibility('Accessible text', 'A hint');
      expect(accessibility.text, equals('Accessible text'));
      expect(accessibility.hint, equals('A hint'));
    });

    test('should create Accessibility with a non-null text and null hint', () {
      final accessibility = Accessibility('Accessible text', null);
      expect(accessibility.text, equals('Accessible text'));
      expect(accessibility.hint, isNull);
    });

    test('toString returns the expected string representation', () {
      final accessibility = Accessibility('Text value', 'Hint value');
      expect(
        accessibility.toString(),
        equals('Accessibility(text: Text value, hint: Hint value)'),
      );
    });

    test('should create Accessibility with a null text and null hint', () {
      final accessibility = Accessibility(null, null);
      expect(accessibility.text, isNull);
      expect(accessibility.hint, isNull);
    });
  });
}

