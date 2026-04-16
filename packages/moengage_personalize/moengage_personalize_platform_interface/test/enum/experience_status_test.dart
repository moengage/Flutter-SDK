import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('ExperienceStatus', () {
    test('fromString returns correct enum for valid strings', () {
      expect(ExperienceStatus.fromString('active'), ExperienceStatus.active);
      expect(ExperienceStatus.fromString('paused'), ExperienceStatus.paused);
      expect(
          ExperienceStatus.fromString('scheduled'), ExperienceStatus.scheduled);
    });

    test('fromString returns active as default for unknown string', () {
      expect(ExperienceStatus.fromString('unknown'), ExperienceStatus.active);
      expect(ExperienceStatus.fromString(''), ExperienceStatus.active);
    });

    test('value returns correct string for each member', () {
      expect(ExperienceStatus.active.value, 'active');
      expect(ExperienceStatus.paused.value, 'paused');
      expect(ExperienceStatus.scheduled.value, 'scheduled');
    });
  });
}
