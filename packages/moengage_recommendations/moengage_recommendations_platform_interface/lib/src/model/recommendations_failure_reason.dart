import 'package:moengage_flutter/moengage_flutter.dart'
    show CommonFailureReason, Logger, MoERequestFailureReason;

import '../internal/constants.dart';

/// Recommendations-specific reasons a recommendations request failed.
///
/// Not exhaustive — Core raises other [MoERequestFailureReason] reasons too (see
/// [CommonFailureReason]), so [fromString] falls back to those before defaulting to
/// [CommonFailureReason.unknownError]. This enum implements [MoERequestFailureReason] directly,
/// the same way [CommonFailureReason] does, rather than inheriting from it — Dart enums cannot
/// extend one another.
enum RecommendationsFailureReason implements MoERequestFailureReason {
  /// The `recommendationId` was blank, or the server rejected the request — HTTP 400.
  invalidRequest('INVALID_REQUEST'),

  /// The request body exceeded the server's size limit — HTTP 413.
  payloadTooLarge('PAYLOAD_TOO_LARGE'),

  /// Fair-use-policy rate limit exceeded — HTTP 429.
  rateLimitExceeded('RATE_LIMIT_EXCEEDED'),

  /// The server failed to process the request — HTTP 500.
  internalServerError('INTERNAL_SERVER_ERROR'),

  /// The server responded with an unhandled status code.
  unknownError('UNKNOWN_ERROR');

  const RecommendationsFailureReason(this.value);

  @override
  final String value;

  /// Get the [MoERequestFailureReason] matching a JSON string value.
  ///
  /// Tries this enum's recommendations-specific reasons first, then falls back to
  /// [CommonFailureReason] for the reasons shared across features, and finally to
  /// [CommonFailureReason.unknownError] when [str] matches neither.
  static MoERequestFailureReason fromString(String str) {
    for (final reason in RecommendationsFailureReason.values) {
      if (reason.value == str) {
        return reason;
      }
    }
    final common = CommonFailureReason.tryFromString(str);
    if (common != null) {
      return common;
    }
    Logger.w(
        '${moduleTag}RecommendationsFailureReason fromString(): Unknown value "$str", defaulting to unknownError');
    return CommonFailureReason.unknownError;
  }
}
