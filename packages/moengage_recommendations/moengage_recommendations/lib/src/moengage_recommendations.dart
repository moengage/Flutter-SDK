import 'package:moengage_flutter/moengage_flutter.dart' show Logger;
import 'package:moengage_recommendations_platform_interface/moengage_recommendations_platform_interface.dart';

/// Helper class to interact with MoEngage Recommendations APIs.
class MoEngageRecommendations {
  /// [MoEngageRecommendations] Constructor
  MoEngageRecommendations(this.appId);

  /// AppId available in MoEngage Platform.
  final String appId;

  static const String _tag = '${moduleTag}MoEngageRecommendations';

  final MoEngageRecommendationsPlatform _platform =
      MoEngageRecommendationsPlatform.instance;

  /// Fetches the recommended items associated with [recommendationId].
  ///
  /// Items are served from the local cache while a non-expired entry exists; otherwise the SDK
  /// fetches them from the server and caches the response.
  ///
  /// [recommendationId] - Recommendation ID defined on the dashboard. Must not be blank.
  /// [itemId] - Item ID defined on the dashboard. Ignored when blank.
  /// [includedFields] - Fields to return for each item, over and above the core fields. Ignored
  /// when empty. Duplicates are dropped.
  ///
  /// Returns [RecommendedItems] on success. An empty item list is a success — it means there are
  /// no recommendations for this user.
  /// Throws [RecommendationsFailure] on failure.
  Future<RecommendedItems> fetchRecommendations(
    String recommendationId, {
    String itemId = '',
    Set<String> includedFields = const {},
  }) async {
    Logger.v('$_tag fetchRecommendations(): recommendationId: '
        '$recommendationId, itemId: $itemId, includedFields: $includedFields');
    return _platform.fetchRecommendations(
        recommendationId, itemId, includedFields, appId);
  }
}
