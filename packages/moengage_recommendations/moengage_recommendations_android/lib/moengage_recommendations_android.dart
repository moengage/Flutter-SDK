import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger;
import 'package:moengage_recommendations_platform_interface/moengage_recommendations_platform_interface.dart';

/// The Android implementation of [MoEngageRecommendationsPlatform].
class MoEngageRecommendationsAndroid extends MoEngageRecommendationsPlatform {
  final String _tag = '${moduleTag}MoEngageRecommendationsAndroid';
  final MethodChannel _channel = const MethodChannel(channelName);

  /// Registers this class as the default instance of [MoEngageRecommendationsPlatform].
  static void registerWith() {
    Logger.v(
        '${moduleTag}MoEngageRecommendationsAndroid registerWith(): Registering MoEngageRecommendationsAndroid with Platform Interface');
    MoEngageRecommendationsPlatform.instance = MoEngageRecommendationsAndroid();
  }

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
      final response = await _channel.invokeMethod(
          methodFetchRecommendations, json.encode(payload));
      return deserializeRecommendedItems(response);
    } catch (e, stackTrace) {
      Logger.e('$_tag fetchRecommendations(): Error: $e',
          stackTrace: stackTrace);
      throw toRecommendationsFailure(e);
    }
  }
}
