import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('ExperienceCampaign', () {
    test('constructor sets all fields correctly', () {
      final campaign = ExperienceCampaign(
        experienceKey: 'banner',
        payload: {'title': 'Hello'},
        experienceContext: {'campaignId': 'c1'},
        source: DataSource.network,
      );
      expect(campaign.experienceKey, 'banner');
      expect(campaign.payload, {'title': 'Hello'});
      expect(campaign.experienceContext, {'campaignId': 'c1'});
      expect(campaign.source, DataSource.network);
    });

    test('handles empty payload and context', () {
      final campaign = ExperienceCampaign(
        experienceKey: 'key',
        payload: {},
        experienceContext: {},
        source: DataSource.cache,
      );
      expect(campaign.payload, isEmpty);
      expect(campaign.experienceContext, isEmpty);
    });

    test('toString returns expected format', () {
      final campaign = ExperienceCampaign(
        experienceKey: 'banner',
        payload: {},
        experienceContext: {},
        source: DataSource.network,
      );
      expect(campaign.toString(), contains('ExperienceCampaign'));
      expect(campaign.toString(), contains('banner'));
    });
  });
}
