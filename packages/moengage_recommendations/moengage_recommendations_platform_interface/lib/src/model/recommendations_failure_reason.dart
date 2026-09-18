import 'package:moengage_flutter/moengage_flutter.dart' show Logger;

import '../internal/constants.dart';

/// Reason a recommendations request failed.
enum RecommendationsFailureReason {
  /// The `recommendationId` was blank, or the server rejected the request — HTTP 400.
  invalidRequest('INVALID_REQUEST'),

  /// The request body exceeded the server's size limit — HTTP 413.
  payloadTooLarge('PAYLOAD_TOO_LARGE'),

  /// Fair-use-policy rate limit exceeded — HTTP 429.
  rateLimitExceeded('RATE_LIMIT_EXCEEDED'),

  /// The server failed to process the request — HTTP 500.
  internalServerError('INTERNAL_SERVER_ERROR'),

  /// Recommendations is blocked from the dashboard, or disabled in the SDK configuration.
  featureDisabled('FEATURE_DISABLED'),

  /// The SDK is not initialized, or is not in a state that allows the operation.
  sdkState('SDK_STATE'),

  /// A network error occurred while making the request.
  networkError('NETWORK_ERROR'),

  /// The response body could not be parsed.
  parseError('PARSE_ERROR'),

  /// The server responded with an unhandled status code, or the failure could not be classified.
  unknownError('UNKNOWN_ERROR');

  const RecommendationsFailureReason(this.value);

  /// JSON string representation of this reason.
  final String value;

  /// Get [RecommendationsFailureReason] from a JSON string value.
  ///
  /// Falls back to [RecommendationsFailureReason.unknownError] for unknown values — the native
  /// failure reasons are not an exhaustive list, so a reason this enum does not model must not
  /// break the caller.
  static RecommendationsFailureReason fromString(String str) =>
      RecommendationsFailureReason.values.firstWhere(
        (r) => r.value == str,
        orElse: () {
          Logger.w(
              '${moduleTag}RecommendationsFailureReason fromString(): Unknown value "$str", defaulting to unknownError');
          return RecommendationsFailureReason.unknownError;
        },
      );
}
