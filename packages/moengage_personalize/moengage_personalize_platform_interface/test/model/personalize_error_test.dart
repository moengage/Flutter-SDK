import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('PersonalizeError', () {
    test('constructor sets code and message', () {
      final error = PersonalizeError(
        code: 'SDK_NOT_INITIALIZED',
        message: 'SDK is not initialized',
      );
      expect(error.code, 'SDK_NOT_INITIALIZED');
      expect(error.message, 'SDK is not initialized');
    });

    test('implements Exception', () {
      final error = PersonalizeError(code: 'TEST', message: 'test');
      expect(error, isA<Exception>());
    });

    test('can be thrown and caught', () {
      expect(
        () => throw PersonalizeError(code: 'ERR', message: 'fail'),
        throwsA(isA<PersonalizeError>()),
      );
    });

    test('toString returns expected format', () {
      final error = PersonalizeError(
        code: 'NETWORK_ERROR',
        message: 'Timeout',
      );
      expect(error.toString(), contains('PersonalizeError'));
      expect(error.toString(), contains('NETWORK_ERROR'));
      expect(error.toString(), contains('Timeout'));
    });
  });
}
