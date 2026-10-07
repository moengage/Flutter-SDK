package com.moengage.flutter.recommendations

internal const val CHANNEL_NAME = "com.moengage/recommendations"
internal const val MODULE_TAG = "MoEFlutterRecommendations_"

internal const val METHOD_FETCH_RECOMMENDATIONS = "fetchRecommendations"

/**
 * Reason reported to Dart when the bridge itself fails before the plugin-base helper can report a
 * reason of its own. Mirrors `RecommendationsFailureReason.unknownError` on the Dart side.
 */
internal const val REASON_UNKNOWN_ERROR = "UNKNOWN_ERROR"
