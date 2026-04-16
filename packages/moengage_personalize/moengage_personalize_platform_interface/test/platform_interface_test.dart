import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';
import 'package:moengage_personalize_platform_interface/src/method_channel_moengage_personalize.dart';

import 'data/json_data_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(CHANNEL_NAME);
  final List<String> invokedMethods = [];

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    invokedMethods.add(methodCall.method);
    switch (methodCall.method) {
      case METHOD_NAME_FETCH_EXPERIENCES_META:
        return fetchExperiencesMetaSuccessJson;
      case METHOD_NAME_FETCH_EXPERIENCES:
        return fetchExperiencesSuccessJson;
      case METHOD_NAME_TRACK_EXPERIENCE_SHOWN:
      case METHOD_NAME_TRACK_EXPERIENCE_CLICKED:
      case METHOD_NAME_TRACK_OFFERING_SHOWN:
      case METHOD_NAME_TRACK_OFFERING_CLICKED:
        return null;
      default:
        return null;
    }
  });

  late MethodChannelMoEngagePersonalize platform;

  setUp(() {
    invokedMethods.clear();
    platform = MethodChannelMoEngagePersonalize();
  });

  group('Fetch APIs', () {
    test('fetchExperiencesMeta invokes correct method and parses response',
        () async {
      final result = await platform.fetchExperiencesMeta(
          [ExperienceStatus.active], testAppId);
      expect(invokedMethods, contains(METHOD_NAME_FETCH_EXPERIENCES_META));
      expect(result, isA<ExperienceCampaignsMetadata>());
      expect(result.source, DataSource.cache);
      expect(result.experiences.length, 2);
    });

    test('fetchExperiences invokes correct method and parses response',
        () async {
      final result =
          await platform.fetchExperiences(['banner'], {}, testAppId);
      expect(invokedMethods, contains(METHOD_NAME_FETCH_EXPERIENCES));
      expect(result, isA<ExperienceCampaignsResult>());
      expect(result.experiences.length, 1);
      expect(result.failures.length, 1);
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
      expect(invokedMethods, contains(METHOD_NAME_TRACK_EXPERIENCE_SHOWN));
    });

    test('trackExperienceClicked invokes correct method', () {
      platform.trackExperienceClicked(campaign, testAppId);
      expect(invokedMethods, contains(METHOD_NAME_TRACK_EXPERIENCE_CLICKED));
    });

    test('trackOfferingShown invokes correct method', () {
      platform.trackOfferingShown([{'id': '1'}], testAppId);
      expect(invokedMethods, contains(METHOD_NAME_TRACK_OFFERING_SHOWN));
    });

    test('trackOfferingClicked invokes correct method', () {
      platform.trackOfferingClicked(campaign, {'id': '1'}, testAppId);
      expect(invokedMethods, contains(METHOD_NAME_TRACK_OFFERING_CLICKED));
    });
  });
}
