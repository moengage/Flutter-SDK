import 'common_failure_reason.dart';

/// Failure raised by [unsetUserAttribute].
///
/// Unlike recommendations, Core raises no feature-specific reasons for this request - the
/// contract lists exactly [CommonFailureReason.invalidParameters],
/// [CommonFailureReason.invalidInitialisationConfiguration], [CommonFailureReason.sdkState] and
/// [CommonFailureReason.unknownError], so [failureReason] is typed directly as
/// [CommonFailureReason] rather than the composed `MoERequestFailureReason` interface
/// recommendations uses to also accommodate its own feature-specific reasons.
class UnsetUserAttributeFailure implements Exception {
  /// [UnsetUserAttributeFailure] Constructor
  UnsetUserAttributeFailure({
    required this.failureReason,
    required this.message,
  });

  /// Reason the unset request failed.
  final CommonFailureReason failureReason;

  /// Human-readable failure message.
  final String message;

  @override
  String toString() {
    return 'UnsetUserAttributeFailure{failureReason: $failureReason, message: $message}';
  }
}
