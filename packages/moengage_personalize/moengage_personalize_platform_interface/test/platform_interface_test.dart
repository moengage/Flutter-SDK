import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show keyData;
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

import 'data/json_data_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(channelName);
  final List<String> invokedMethods = [];
  // Captures the wire-side payload as a Map regardless of whether the platform
  // implementation passes a Map<String, dynamic> directly (iOS, base class) or
  // a JSON-encoded string (Android override). Lets plural-tracking integration
  // tests below assert that all entries reach the wire.
  final Map<String, Map<String, dynamic>> lastPayloadByMethod = {};

  late MethodChannelMoEngagePersonalize platform;

  setUp(() {
    invokedMethods.clear();
    lastPayloadByMethod.clear();
    platform = MethodChannelMoEngagePersonalize();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      invokedMethods.add(methodCall.method);
      final args = methodCall.arguments;
      if (args is Map) {
        lastPayloadByMethod[methodCall.method] =
            Map<String, dynamic>.from(args);
      } else if (args is String) {
        lastPayloadByMethod[methodCall.method] =
            json.decode(args) as Map<String, dynamic>;
      }
      switch (methodCall.method) {
        case methodFetchExperiencesMeta:
          return fetchExperiencesMetaSuccessJson;
        case methodFetchExperiences:
          return fetchExperiencesSuccessJson;
        case methodExperiencesShown:
        case methodExperienceClicked:
        case methodOfferingsShown:
        case methodOfferingClicked:
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

    test('experiencesShown invokes correct method', () {
      platform.experiencesShown([campaign], testAppId);
      expect(invokedMethods, contains(methodExperiencesShown));
    });

    test('experienceClicked invokes correct method', () {
      platform.experienceClicked(campaign, testAppId);
      expect(invokedMethods, contains(methodExperienceClicked));
    });

    test('offeringsShown invokes correct method', () {
      platform.offeringsShown([{'id': '1'}], testAppId);
      expect(invokedMethods, contains(methodOfferingsShown));
    });

    test('offeringClicked invokes correct method', () {
      platform.offeringClicked(campaign, {'id': '1'}, testAppId);
      expect(invokedMethods, contains(methodOfferingClicked));
    });

    // Regression guards for the "plural API drops items past the first" bug:
    // every campaign/offering passed to the plural APIs must reach the wire.
    test('experiencesShown forwards ALL campaigns to the wire payload', () async {
      final campaigns = List.generate(
        3,
        (i) => ExperienceCampaign(
          experienceKey: 'exp_$i',
          payload: {'idx': i},
          experienceContext: {'ctx': '$i'},
          source: DataSource.network,
        ),
      );

      platform.experiencesShown(campaigns, testAppId);

      final wire = lastPayloadByMethod[methodExperiencesShown];
      expect(wire, isNotNull,
          reason: 'experiencesShown should send a payload over the channel');
      final data = wire![keyData] as Map;
      final experiences = data[keyExperiences] as List;
      expect(experiences.length, 3,
          reason: 'all 3 campaigns must reach the native side');
      expect(
        experiences.map((e) => (e as Map)[keyExperienceKey]).toList(),
        ['exp_0', 'exp_1', 'exp_2'],
        reason: 'order preserved and no entry dropped',
      );
    });

    test('offeringsShown forwards ALL offering payloads to the wire payload',
        () async {
      final offerings = List.generate(3, (i) => {'offer_id': 'o_$i', 'idx': i});

      platform.offeringsShown(offerings, testAppId);

      final wire = lastPayloadByMethod[methodOfferingsShown];
      expect(wire, isNotNull);
      final data = wire![keyData] as Map;
      final wireOfferings = data[keyOfferingPayloads] as List;
      expect(wireOfferings.length, 3);
      expect(
        wireOfferings.map((e) => (e as Map)['offer_id']).toList(),
        ['o_0', 'o_1', 'o_2'],
      );
    });
  });
}
