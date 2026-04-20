import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

import 'data/json_data_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(channelName);
  final List<String> invokedMethods = [];

  late MethodChannelMoEngagePersonalize platform;

  setUp(() {
    invokedMethods.clear();
    platform = MethodChannelMoEngagePersonalize();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      invokedMethods.add(methodCall.method);
      switch (methodCall.method) {
        case methodFetchExperiencesMeta:
          return fetchExperiencesMetaSuccessJson;
        case methodFetchExperiences:
          return fetchExperiencesSuccessJson;
        case methodTrackExperienceShown:
        case methodTrackExperienceClicked:
        case methodTrackOfferingShown:
        case methodTrackOfferingClicked:
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('Fetch APIs', () {
    test('fetchExperiencesMeta invokes correct method and parses response',
        () async {
      final result = await platform.fetchExperiencesMeta(
          [ExperienceStatus.active], testAppId);
      expect(invokedMethods, contains(methodFetchExperiencesMeta));
      expect(result, isA<ExperienceCampaignsMetadata>());
      expect(result.source, DataSource.cache);
      expect(result.experiences.length, 2);
    });

    test('fetchExperiencesMeta throws PersonalizeError on error response',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return fetchExperiencesMetaErrorJson;
      });
      expect(
        () => platform.fetchExperiencesMeta([], testAppId),
        throwsA(isA<PersonalizeError>()
            .having((e) => e.code, 'code', 'SDK_NOT_INITIALIZED')),
      );
    });

    test('fetchExperiences invokes correct method and parses response',
        () async {
      final result =
          await platform.fetchExperiences(['banner'], {}, testAppId);
      expect(invokedMethods, contains(methodFetchExperiences));
      expect(result, isA<ExperienceCampaignsResult>());
      expect(result.experiences.length, 1);
      expect(result.failures.length, 1);
    });

    test('fetchExperiences throws PersonalizeError on error response',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return fetchExperiencesErrorJson;
      });
      expect(
        () => platform.fetchExperiences([], {}, testAppId),
        throwsA(isA<PersonalizeError>()
            .having((e) => e.code, 'code', 'NETWORK_ERROR')
            .having((e) => e.message, 'message', 'Request timed out')),
      );
    });
  });

  group('Tracking APIs', () {
    final campaign = ExperienceCampaign(
      experienceKey: 'test',
      payload: {},
      experienceContext: {},
      source: DataSource.network,
    );

    test('trackExperienceShown invokes correct method', () {
      platform.trackExperienceShown([campaign], testAppId);
      expect(invokedMethods, contains(methodTrackExperienceShown));
    });

    test('trackExperienceClicked invokes correct method', () {
      platform.trackExperienceClicked(campaign, testAppId);
      expect(invokedMethods, contains(methodTrackExperienceClicked));
    });

    test('trackOfferingShown invokes correct method', () {
      platform.trackOfferingShown([{'id': '1'}], testAppId);
      expect(invokedMethods, contains(methodTrackOfferingShown));
    });

    test('trackOfferingClicked invokes correct method', () {
      platform.trackOfferingClicked(campaign, {'id': '1'}, testAppId);
      expect(invokedMethods, contains(methodTrackOfferingClicked));
    });
  });
}
