import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('ExperienceCampaignsResult', () {
    test('constructor sets all fields correctly', () {
      final campaign = ExperienceCampaign(
        experienceKey: 'banner',
        payload: {},
        experienceContext: {},
        source: DataSource.network,
      );
      final failure = ExperienceCampaignFailure(
        reason: ExperienceFailureReason.invalidExperienceKey,
        experienceKeys: ['bad_key'],
      );
      final result = ExperienceCampaignsResult(
        experiences: [campaign],
        failures: [failure],
      );
      expect(result.experiences.length, 1);
      expect(result.failures.length, 1);
      expect(result.experiences.first.experienceKey, 'banner');
      expect(result.failures.first.reason,
          ExperienceFailureReason.invalidExperienceKey);
    });

    test('handles empty lists', () {
      final result = ExperienceCampaignsResult(
        experiences: [],
        failures: [],
      );
      expect(result.experiences, isEmpty);
      expect(result.failures, isEmpty);
    });

    test('toString returns expected format', () {
      final result = ExperienceCampaignsResult(
        experiences: [],
        failures: [],
      );
      expect(result.toString(), contains('ExperienceCampaignsResult'));
    });
  });
}
