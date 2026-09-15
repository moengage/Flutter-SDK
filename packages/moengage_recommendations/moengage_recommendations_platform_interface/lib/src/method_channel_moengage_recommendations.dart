import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger;

import 'internal/constants.dart';
import 'internal/payload_mapper.dart';
import 'model/models.dart';
import 'moengage_recommendations_platform_interface.dart';

/// An implementation of [MoEngageRecommendationsPlatform] that uses method channels.
class MethodChannelMoEngageRecommendations
    extends MoEngageRecommendationsPlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel(channelName);

  static const String _tag = '${moduleTag}MethodChannelMoEngageRecommendations';

  @override
  Future<RecommendedItems> fetchRecommendations(
    String recommendationId,
    String itemId,
    Set<String> includedFields,
    String appId,
  ) async {
    final Map<String, dynamic> payload = getFetchRecommendationsPayload(
        recommendationId, itemId, includedFields, appId);
    Logger.v('$_tag fetchRecommendations(): $payload');
    try {
      final response =
          await _channel.invokeMethod(methodFetchRecommendations, payload);
      return deserializeRecommendedItems(response);
    } catch (e, stackTrace) {
      Logger.e('$_tag fetchRecommendations(): Error: $e',
          stackTrace: stackTrace);
      throw toRecommendationsFailure(e);
    }
  }
}
