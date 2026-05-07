import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('ExperienceCampaignsMetadata', () {
    test('constructor sets all fields correctly', () {
      final meta = ExperienceCampaignMeta(
        experienceKey: 'k1',
        experienceName: 'N1',
        status: ExperienceStatus.active,
      );
      final metadata = ExperienceCampaignsMetadata(
        source: DataSource.cache,
        experiences: [meta],
      );
      expect(metadata.source, DataSource.cache);
      expect(metadata.experiences.length, 1);
      expect(metadata.experiences.first.experienceKey, 'k1');
    });

    test('handles empty experiences list', () {
      final metadata = ExperienceCampaignsMetadata(
        source: DataSource.network,
        experiences: [],
      );
      expect(metadata.experiences, isEmpty);
    });

    test('toString returns expected format', () {
      final metadata = ExperienceCampaignsMetadata(
        source: DataSource.cache,
        experiences: [],
      );
      expect(metadata.toString(), contains('ExperienceCampaignsMetadata'));
      expect(metadata.toString(), contains('cache'));
    });
  });
}
