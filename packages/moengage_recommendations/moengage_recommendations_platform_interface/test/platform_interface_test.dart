import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show keyData;
import 'package:moengage_recommendations_platform_interface/moengage_recommendations_platform_interface.dart';

import 'data/json_data_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(channelName);
  final List<String> invokedMethods = [];
  // Captures the wire-side payload as a Map regardless of whether the platform
  // implementation passes a Map<String, dynamic> directly (base class) or a
  // JSON-encoded string (Android override).
  final Map<String, Map<String, dynamic>> lastPayloadByMethod = {};

  late MethodChannelMoEngageRecommendations platform;

  void mockResponse(String response) {
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
      return response;
    });
  }

  setUp(() {
    invokedMethods.clear();
    lastPayloadByMethod.clear();
    platform = MethodChannelMoEngageRecommendations();
    mockResponse(fetchRecommendationsSuccessJson);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('fetchRecommendations', () {
    test('invokes the correct method and parses the response', () async {
      final result = await platform.fetchRecommendations(
          testRecommendationId, testItemId, {'size', 'color'}, testAppId);

      expect(invokedMethods, contains(methodFetchRecommendations));
      expect(result, isA<RecommendedItems>());
      expect(result.items.length, 2);
      expect(result.items.first['product_id'], 'product_001');
    });

    test('preserves the catalog value types', () async {
      final result = await platform.fetchRecommendations(
          testRecommendationId, '', const {}, testAppId);

      // A catalog price is a number, and 199.99 vs 200 do not decode to the same Dart type —
      // reading either as `num` is the only safe cast.
      expect(result.items[0]['price'], isA<double>());
      expect(result.items[1]['price'], isA<int>());
      expect((result.items[0]['price'] as num).toDouble(), 199.99);
      expect((result.items[1]['price'] as num).toDouble(), 200.0);
      expect(result.items[1]['in_stock'], isTrue);
    });

    test('sends the recommendation criteria on the wire', () async {
      // Built from a list rather than a set literal so the duplicate survives to the call —
      // a literal `{'size', 'color', 'size'}` is rejected by the analyzer.
      final includedFields = <String>{...['size', 'color', 'size']};

      await platform.fetchRecommendations(
          testRecommendationId, testItemId, includedFields, testAppId);

      final wire = lastPayloadByMethod[methodFetchRecommendations];
      expect(wire, isNotNull);
      final data = wire![keyData] as Map;
      expect(data[keyRecommendationId], testRecommendationId);
      expect(data[keyItemId], testItemId);
      // includedFields is a set in the contract, so the duplicate is dropped.
      expect((data[keyIncludedFields] as List).length, 2);
      expect(data[keyIncludedFields], containsAll(<String>['size', 'color']));
    });

    test('treats an empty item list as a success', () async {
      mockResponse(fetchRecommendationsEmptyJson);

      final result = await platform.fetchRecommendations(
          testRecommendationId, '', const {}, testAppId);

      expect(result.items, isEmpty);
    });

    test('returns an empty result when the data block is missing', () async {
      mockResponse(fetchRecommendationsMalformedJson);

      final result = await platform.fetchRecommendations(
          testRecommendationId, '', const {}, testAppId);

      expect(result.items, isEmpty);
    });

    test(
        'throws RecommendationsFailure with parseError for a response body that '
        'is not valid JSON', () async {
      // json.decode() itself throws here, unlike the missing-data-block case above where
      // decoding succeeds and only the `data` key is absent — this exercises
      // deserializeRecommendedItems()'s own catch block, and confirms toRecommendationsFailure()
      // passes an already-classified RecommendationsFailure through unchanged rather than
      // reclassifying it as unknownError.
      mockResponse('not-json');

      expect(
        () => platform.fetchRecommendations(
            testRecommendationId, '', const {}, testAppId),
        throwsA(isA<RecommendationsFailure>().having((e) => e.failureReason,
            'failureReason', RecommendationsFailureReason.parseError)),
      );
    });

    test('throws RecommendationsFailure with the native failure reason',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(
            code: 'INVALID_REQUEST', message: 'Recommendation id is blank');
      });

      expect(
        () => platform.fetchRecommendations('', '', const {}, testAppId),
        throwsA(isA<RecommendationsFailure>()
            .having((e) => e.failureReason, 'failureReason',
                RecommendationsFailureReason.invalidRequest)
            .having((e) => e.message, 'message', 'Recommendation id is blank')),
      );
    });

    test('falls back to unknownError for an unmodelled failure reason',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'SOME_NEW_REASON', message: 'boom');
      });

      expect(
        () => platform.fetchRecommendations(
            testRecommendationId, '', const {}, testAppId),
        throwsA(isA<RecommendationsFailure>().having((e) => e.failureReason,
            'failureReason', RecommendationsFailureReason.unknownError)),
      );
    });
  });

  group('RecommendationsFailureReason', () {
    test('maps every contract value from its string', () {
      expect(RecommendationsFailureReason.fromString('INVALID_REQUEST'),
          RecommendationsFailureReason.invalidRequest);
      expect(RecommendationsFailureReason.fromString('PAYLOAD_TOO_LARGE'),
          RecommendationsFailureReason.payloadTooLarge);
      expect(RecommendationsFailureReason.fromString('RATE_LIMIT_EXCEEDED'),
          RecommendationsFailureReason.rateLimitExceeded);
      expect(RecommendationsFailureReason.fromString('INTERNAL_SERVER_ERROR'),
          RecommendationsFailureReason.internalServerError);
      expect(RecommendationsFailureReason.fromString('UNKNOWN_ERROR'),
          RecommendationsFailureReason.unknownError);
    });

    test('maps the shared core reasons from their string', () {
      expect(RecommendationsFailureReason.fromString('FEATURE_DISABLED'),
          RecommendationsFailureReason.featureDisabled);
      expect(RecommendationsFailureReason.fromString('SDK_STATE'),
          RecommendationsFailureReason.sdkState);
      expect(RecommendationsFailureReason.fromString('NETWORK_ERROR'),
          RecommendationsFailureReason.networkError);
      expect(RecommendationsFailureReason.fromString('PARSE_ERROR'),
          RecommendationsFailureReason.parseError);
    });
  });
}
