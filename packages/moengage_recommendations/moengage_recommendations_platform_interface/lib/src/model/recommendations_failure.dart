import 'recommendations_failure_reason.dart';

/// Failure raised by a recommendations request.
///
/// Thrown by the fetch APIs. An empty item list is a success, not a failure — it means there are
/// no recommendations for this user.
class RecommendationsFailure implements Exception {
  /// [RecommendationsFailure] Constructor
  RecommendationsFailure({
    required this.failureReason,
    required this.message,
  });

  /// Reason for the failure.
  final RecommendationsFailureReason failureReason;

  /// Human-readable failure message.
  final String message;

  @override
  String toString() {
    return 'RecommendationsFailure{failureReason: $failureReason, message: $message}';
  }
}
