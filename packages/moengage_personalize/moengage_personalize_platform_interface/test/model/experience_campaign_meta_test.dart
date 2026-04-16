import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('ExperienceCampaignMeta', () {
    test('constructor sets all fields correctly', () {
      final meta = ExperienceCampaignMeta(
        experienceKey: 'key1',
        experienceName: 'Name 1',
        status: ExperienceStatus.active,
      );
      expect(meta.experienceKey, 'key1');
      expect(meta.experienceName, 'Name 1');
      expect(meta.status, ExperienceStatus.active);
    });

    test('toString returns expected format', () {
      final meta = ExperienceCampaignMeta(
        experienceKey: 'key1',
        experienceName: 'Name 1',
        status: ExperienceStatus.paused,
      );
      expect(
        meta.toString(),
        'ExperienceCampaignMeta{experienceKey: key1, experienceName: Name 1, status: ExperienceStatus.paused}',
      );
    });
  });
}
