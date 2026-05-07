import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('ExperienceCampaignFailure', () {
    test('constructor sets required fields correctly', () {
      final failure = ExperienceCampaignFailure(
        reason: ExperienceFailureReason.userNotInSegment,
        experienceKeys: ['key1', 'key2'],
      );
      expect(failure.reason, ExperienceFailureReason.userNotInSegment);
      expect(failure.experienceKeys, ['key1', 'key2']);
    });

    test('handles empty experienceKeys list', () {
      final failure = ExperienceCampaignFailure(
        reason: ExperienceFailureReason.invalidExperienceKey,
        experienceKeys: [],
      );
      expect(failure.experienceKeys, isEmpty);
    });

    test('toString returns expected format', () {
      final failure = ExperienceCampaignFailure(
        reason: ExperienceFailureReason.personalizationFailed,
        experienceKeys: ['k1'],
      );
      expect(failure.toString(), contains('ExperienceCampaignFailure'));
      expect(failure.toString(), contains('personalizationFailed'));
    });
  });
}
