import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moengage_personalize/moengage_personalize.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoEngagePersonalizePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements MoEngagePersonalizePlatform {}

const String _appId = 'TEST_APP_ID';

void main() {
  setUpAll(() {
    registerFallbackValue(ExperienceCampaign(
      experienceKey: '',
      payload: {},
      experienceContext: {},
      source: DataSource.network,
    ));
    registerFallbackValue(<ExperienceCampaign>[]);
    registerFallbackValue(<ExperienceStatus>[]);
    registerFallbackValue(<Map<String, dynamic>>[]);
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<String>[]);
    registerFallbackValue(<String, String>{});
  });

  late MockMoEngagePersonalizePlatform mockPlatform;
  late MoEngagePersonalize personalize;

  final stubMeta = ExperienceCampaignsMetadata(
    source: DataSource.cache,
    experiences: [],
  );

  final stubResult = ExperienceCampaignsResult(
    experiences: [],
    failures: [],
  );

  final campaign = ExperienceCampaign(
    experienceKey: 'test',
    payload: {},
    experienceContext: {},
    source: DataSource.network,
  );

  setUp(() {
    mockPlatform = MockMoEngagePersonalizePlatform();
    MoEngagePersonalizePlatform.instance = mockPlatform;
    personalize = MoEngagePersonalize(_appId);

    when(() => mockPlatform.fetchExperiencesMeta(any(), any()))
        .thenAnswer((_) async => stubMeta);
    when(() => mockPlatform.fetchExperiences(any(), any(), any()))
        .thenAnswer((_) async => stubResult);
    when(() => mockPlatform.experiencesShown(any(), any()))
        .thenReturn(null);
    when(() => mockPlatform.experienceClicked(any(), any()))
        .thenReturn(null);
    when(() => mockPlatform.offeringsShown(any(), any()))
        .thenReturn(null);
    when(() => mockPlatform.offeringClicked(any(), any(), any()))
        .thenReturn(null);
  });

  group('MoEngagePersonalize', () {
    test('fetchExperiencesMeta forwards statuses and appId to platform',
        () async {
      final statuses = [ExperienceStatus.active];
      await personalize.fetchExperiencesMeta(statuses);
      verify(() => mockPlatform.fetchExperiencesMeta(statuses, _appId))
          .called(1);
    });

    test('fetchExperiences forwards keys, attributes and appId to platform',
        () async {
      final keys = ['banner'];
      final attrs = {'locale': 'en'};
      await personalize.fetchExperiences(keys, attributes: attrs);
      verify(() => mockPlatform.fetchExperiences(keys, attrs, _appId))
          .called(1);
    });

    test('fetchExperience wraps single key and forwards to platform', () async {
      await personalize.fetchExperience('hero');
      verify(() => mockPlatform.fetchExperiences(['hero'], {}, _appId))
          .called(1);
    });

    test('experiencesShown forwards campaigns and appId to platform', () {
      personalize.experiencesShown([campaign]);
      verify(() => mockPlatform.experiencesShown([campaign], _appId))
          .called(1);
    });

    test('experienceClicked forwards campaign and appId to platform', () {
      personalize.experienceClicked(campaign);
      verify(() => mockPlatform.experienceClicked(campaign, _appId))
          .called(1);
    });

    test('offeringsShown forwards payloads and appId to platform', () {
      final offeringPayloads = [{'id': '1'}];
      personalize.offeringsShown(offeringPayloads);
      verify(() => mockPlatform.offeringsShown(offeringPayloads, _appId)).called(1);
    });

    test('offeringClicked forwards campaign, payload and appId to platform', () {
      final offeringPayload = {'id': '1'};
      personalize.offeringClicked(campaign, offeringPayload);
      verify(() =>
              mockPlatform.offeringClicked(campaign, offeringPayload, _appId))
          .called(1);
    });
  });
}
