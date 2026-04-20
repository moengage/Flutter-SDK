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
    when(() => mockPlatform.trackExperienceShown(any(), any()))
        .thenReturn(null);
    when(() => mockPlatform.trackExperienceClicked(any(), any()))
        .thenReturn(null);
    when(() => mockPlatform.trackOfferingShown(any(), any()))
        .thenReturn(null);
    when(() => mockPlatform.trackOfferingClicked(any(), any(), any()))
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

    test('trackExperienceShown forwards campaigns and appId to platform', () {
      personalize.trackExperienceShown([campaign]);
      verify(() => mockPlatform.trackExperienceShown([campaign], _appId))
          .called(1);
    });

    test('trackExperienceClicked forwards campaign and appId to platform', () {
      personalize.trackExperienceClicked(campaign);
      verify(() => mockPlatform.trackExperienceClicked(campaign, _appId))
          .called(1);
    });

    test('trackOfferingShown forwards attributes and appId to platform', () {
      final attrs = [{'id': '1'}];
      personalize.trackOfferingShown(attrs);
      verify(() => mockPlatform.trackOfferingShown(attrs, _appId)).called(1);
    });

    test('trackOfferingClicked forwards campaign, attributes and appId', () {
      final attrs = {'id': '1'};
      personalize.trackOfferingClicked(campaign, attrs);
      verify(() =>
              mockPlatform.trackOfferingClicked(campaign, attrs, _appId))
          .called(1);
    });
  });
}
