import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('ExperienceCampaignFailure', () {
    test('constructor sets required fields correctly', () {
      final failure = ExperienceCampaignFailure(
        reason: 'USER_NOT_IN_SEGMENT',
        experienceKeys: ['key1', 'key2'],
      );
      expect(failure.reason, 'USER_NOT_IN_SEGMENT');
      expect(failure.experienceKeys, ['key1', 'key2']);
      expect(failure.message, isNull);
    });

    test('constructor sets optional message when provided', () {
      final failure = ExperienceCampaignFailure(
        reason: 'NETWORK_ERROR',
        experienceKeys: ['key1'],
        message: 'Timeout',
      );
      expect(failure.reason, 'NETWORK_ERROR');
      expect(failure.message, 'Timeout');
    });

    test('handles empty experienceKeys list', () {
      final failure = ExperienceCampaignFailure(
        reason: 'UNKNOWN',
        experienceKeys: [],
      );
      expect(failure.experienceKeys, isEmpty);
    });

    test('toString returns expected format', () {
      final failure = ExperienceCampaignFailure(
        reason: 'PARSE_ERROR',
        experienceKeys: ['k1'],
        message: 'Bad JSON',
      );
      expect(failure.toString(), contains('ExperienceCampaignFailure'));
      expect(failure.toString(), contains('PARSE_ERROR'));
      expect(failure.toString(), contains('Bad JSON'));
    });
  });
}
