import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show keyAccountMeta, keyAppId, keyData;
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

import 'data/json_data_provider.dart';
import 'data/model_data_provider.dart';

void main() {
  group('Serialization (Dart → JSON)', () {
    test('getFetchExperiencesMetaPayload builds correct structure', () {
      final payload = getFetchExperiencesMetaPayload(
        [ExperienceStatus.active, ExperienceStatus.paused],
        testAppId,
      );
      expect(payload[keyAccountMeta], {keyAppId: testAppId});
      final data = payload[keyData] as Map<String, dynamic>;
      expect(data[keyStatus], ['active', 'paused']);
    });

    test('getFetchExperiencesMetaPayload handles empty statuses', () {
      final payload = getFetchExperiencesMetaPayload([], testAppId);
      final data = payload[keyData] as Map<String, dynamic>;
      expect(data[keyStatus], isEmpty);
    });

    test('getFetchExperiencesPayload builds correct structure', () {
      final payload = getFetchExperiencesPayload(
        ['banner', 'hero'],
        {'locale': 'en'},
        testAppId,
      );
      expect(payload[keyAccountMeta], {keyAppId: testAppId});
      final data = payload[keyData] as Map<String, dynamic>;
      expect(data[keyExperienceKeys], ['banner', 'hero']);
      expect(data[keyAttributes], {'locale': 'en'});
    });

    test('getFetchExperiencesPayload handles empty attributes', () {
      final payload = getFetchExperiencesPayload(['key1'], {}, testAppId);
      final data = payload[keyData] as Map<String, dynamic>;
      expect(data[keyAttributes], isEmpty);
    });

    test('campaignToMap serializes campaign correctly', () {
      final map = campaignToMap(experienceCampaign);
      expect(map[keyExperienceKey], 'welcome_banner');
      expect(map[keyPayload], {'title': 'Welcome', 'body': 'Hello World'});
      expect(
          map[keyExperienceContext], {'campaignId': 'c123', 'locale': 'en'});
    });

    test('getTrackExperienceShownPayload wraps campaigns in array', () {
      final payload =
          getTrackExperienceShownPayload([experienceCampaign], testAppId);
      final data = payload[keyData] as Map<String, dynamic>;
      final experiences = data[keyExperiences] as List;
      expect(experiences.length, 1);
      expect(experiences[0][keyExperienceKey], 'welcome_banner');
    });

    test('getTrackExperienceClickedPayload wraps single campaign', () {
      final payload =
          getTrackExperienceClickedPayload(experienceCampaign, testAppId);
      final data = payload[keyData] as Map<String, dynamic>;
      final experience = data[keyExperience] as Map<String, dynamic>;
      expect(experience[keyExperienceKey], 'welcome_banner');
    });

    test('getTrackOfferingShownPayload wraps offering attributes', () {
      final attrs = [
        {'offer_id': '123'}
      ];
      final payload = getTrackOfferingShownPayload(attrs, testAppId);
      final data = payload[keyData] as Map<String, dynamic>;
      expect(data[keyOfferingAttributes], attrs);
    });

    test('getTrackOfferingClickedPayload wraps campaign + attributes', () {
      final attrs = {'offer_id': '123'};
      final payload = getTrackOfferingClickedPayload(
          experienceCampaign, attrs, testAppId);
      final data = payload[keyData] as Map<String, dynamic>;
      expect(data[keyExperience], isA<Map<String, dynamic>>());
      expect(data[keyOfferingAttributes], attrs);
    });
  });

  group('Deserialization (JSON → Dart)', () {
    group('deserializeExperiencesMeta', () {
      test('parses success response correctly', () {
        final result =
            deserializeExperiencesMeta(fetchExperiencesMetaSuccessJson);
        expect(result.source, DataSource.cache);
        expect(result.experiences.length, 2);
        expect(result.experiences[0].experienceKey, 'welcome_banner');
        expect(result.experiences[0].experienceName, 'Welcome Banner');
        expect(result.experiences[0].status, ExperienceStatus.active);
        expect(result.experiences[1].experienceKey, 'home_hero');
        expect(result.experiences[1].status, ExperienceStatus.paused);
      });

      test('throws PersonalizeError on error response', () {
        expect(
          () => deserializeExperiencesMeta(fetchExperiencesMetaErrorJson),
          throwsA(isA<PersonalizeError>().having(
              (e) => e.code, 'code', 'SDK_NOT_INITIALIZED')),
        );
      });
    });

    group('deserializeExperiencesResult', () {
      test('parses success response with experiences and failures', () {
        final result =
            deserializeExperiencesResult(fetchExperiencesSuccessJson);
        expect(result.experiences.length, 1);
        expect(result.experiences[0].experienceKey, 'welcome_banner');
        expect(result.experiences[0].payload, {'title': 'Welcome', 'body': 'Hello World'});
        expect(result.experiences[0].experienceContext,
            {'campaignId': 'c123', 'locale': 'en'});
        expect(result.experiences[0].source, DataSource.network);

        expect(result.failures.length, 1);
        expect(result.failures[0].reason, 'USER_NOT_IN_SEGMENT');
        expect(result.failures[0].experienceKeys, ['home_hero']);
        expect(result.failures[0].message,
            'User does not match segment criteria');
      });

      test('parses empty experiences and failures', () {
        final result =
            deserializeExperiencesResult(fetchExperiencesEmptyJson);
        expect(result.experiences, isEmpty);
        expect(result.failures, isEmpty);
      });

      test('throws PersonalizeError on error response', () {
        expect(
          () => deserializeExperiencesResult(fetchExperiencesErrorJson),
          throwsA(isA<PersonalizeError>()
              .having((e) => e.code, 'code', 'NETWORK_ERROR')
              .having((e) => e.message, 'message', 'Request timed out')),
        );
      });

      test('parses failure without optional message', () {
        final result = deserializeExperiencesResult(
            fetchExperiencesFailureWithoutMessageJson);
        expect(result.failures.length, 1);
        expect(result.failures[0].reason, 'IN_VALID_EXPERIENCE_KEY');
        expect(result.failures[0].experienceKeys, ['bad_key']);
        expect(result.failures[0].message, isNull);
      });
    });
  });
}
