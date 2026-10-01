import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moengage_recommendations/moengage_recommendations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoEngageRecommendationsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements MoEngageRecommendationsPlatform {}

const String _appId = 'TEST_APP_ID';

void main() {
  setUpAll(() {
    registerFallbackValue(<String>{});
  });

  late MockMoEngageRecommendationsPlatform mockPlatform;
  late MoEngageRecommendations recommendations;

  final stubResult = RecommendedItems(items: []);

  setUp(() {
    mockPlatform = MockMoEngageRecommendationsPlatform();
    MoEngageRecommendationsPlatform.instance = mockPlatform;
    recommendations = MoEngageRecommendations(_appId);

    when(() => mockPlatform.fetchRecommendations(any(), any(), any(), any()))
        .thenAnswer((_) async => stubResult);
  });

  group('MoEngageRecommendations', () {
    test('fetchRecommendations forwards every argument and the appId',
        () async {
      await recommendations.fetchRecommendations(
        'clothing',
        itemId: 'shirts',
        includedFields: {'size', 'color'},
      );

      verify(() => mockPlatform.fetchRecommendations(
          'clothing', 'shirts', {'size', 'color'}, _appId)).called(1);
    });

    test('fetchRecommendations defaults the optional arguments', () async {
      await recommendations.fetchRecommendations('clothing');

      verify(() => mockPlatform.fetchRecommendations(
          'clothing', '', <String>{}, _appId)).called(1);
    });

    test('fetchRecommendations returns the platform result', () async {
      final result = await recommendations.fetchRecommendations('clothing');

      expect(result, same(stubResult));
    });

    test('fetchRecommendations propagates a RecommendationsFailure', () async {
      when(() => mockPlatform.fetchRecommendations(any(), any(), any(), any()))
          .thenThrow(RecommendationsFailure(
        failureReason: RecommendationsFailureReason.invalidRequest,
        message: 'Recommendation id is blank',
      ));

      expect(
        () => recommendations.fetchRecommendations(''),
        throwsA(isA<RecommendationsFailure>().having((e) => e.failureReason,
            'failureReason', RecommendationsFailureReason.invalidRequest)),
      );
    });
  });
}
