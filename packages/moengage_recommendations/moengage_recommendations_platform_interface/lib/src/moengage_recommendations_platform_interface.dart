import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_moengage_recommendations.dart';
import 'model/models.dart';

/// Platform Interface for MoEngage Recommendations Feature.
abstract class MoEngageRecommendationsPlatform extends PlatformInterface {
  /// Constructs a MoEngageRecommendationsPlatform.
  MoEngageRecommendationsPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngageRecommendationsPlatform _instance =
      MethodChannelMoEngageRecommendations();

  /// The default instance of [MoEngageRecommendationsPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoEngageRecommendations].
  static MoEngageRecommendationsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MoEngageRecommendationsPlatform] when they register themselves.
  static set instance(MoEngageRecommendationsPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Fetches the recommended items associated with [recommendationId].
  ///
  /// [recommendationId] - Recommendation ID defined on the dashboard. Must not be blank.
  /// [itemId] - Item ID defined on the dashboard. Ignored when blank.
  /// [includedFields] - Fields to return for each item, over and above the core fields. Ignored
  /// when empty.
  /// [appId] - MoEngage App ID.
  ///
  /// Returns [RecommendedItems] on success; an empty item list is a success.
  /// Throws [RecommendationsFailure] on failure.
  Future<RecommendedItems> fetchRecommendations(
    String recommendationId,
    String itemId,
    Set<String> includedFields,
    String appId,
  );
}
