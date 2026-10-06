import '../internal/constants.dart';
import '../internal/logger.dart';
import 'moe_request_failure_reason.dart';

/// Reason common to any MoEngage SDK request failure, not specific to one feature.
///
/// Dart enums cannot extend one another, so this mirrors the native SDKs' design — a generic,
/// shared set of reasons any feature can raise — by having feature-specific failure reason enums
/// implement [MoERequestFailureReason] directly, the same way this enum does, rather than
/// inheriting from it.
enum CommonFailureReason implements MoERequestFailureReason {
  /// The feature is disabled in the SDK configuration, or blocked from the dashboard.
  featureDisabled('FEATURE_DISABLED'),

  /// The SDK is not initialized, or is not in a state that allows the operation.
  sdkState('SDK_STATE'),

  /// An unexpected error occurred on the MoEngage server.
  serverError('SERVER_ERROR'),

  /// A network error occurred while making the request.
  networkError('NETWORK_ERROR'),

  /// The response from the server could not be parsed.
  parseError('PARSE_ERROR'),

  /// The parameters provided to the method were invalid.
  invalidParameters('INVALID_PARAMETERS'),

  /// The configuration used for SDK initialization was invalid.
  invalidInitialisationConfiguration('INVALID_INITIALISATION_CONFIGURATION'),

  /// A duplicate call was made and only the last one is processed.
  duplicateFunctionCall('DUPLICATE_FUNCTION_CALL'),

  /// The request was not authorized.
  authenticationFailed('AUTHENTICATION_FAILED'),

  /// An unknown or unexpected error occurred.
  unknownError('UNKNOWN_ERROR');

  const CommonFailureReason(this.value);

  @override
  final String value;

  /// Get a [CommonFailureReason] from its JSON string value.
  ///
  /// Returns `null` when [str] does not match any common reason, rather than defaulting to
  /// [unknownError] — the caller is expected to try feature-specific reasons first and only fall
  /// back to [unknownError] once both have been exhausted.
  static CommonFailureReason? tryFromString(String str) {
    for (final reason in CommonFailureReason.values) {
      if (reason.value == str) {
        return reason;
      }
    }
    return null;
  }

  /// Get a [CommonFailureReason] from its JSON string value, falling back to [unknownError] and
  /// logging a warning when [str] does not match any common reason.
  static CommonFailureReason fromString(String str) {
    final reason = tryFromString(str);
    if (reason != null) {
      return reason;
    }
    Logger.w(
        '${TAG}CommonFailureReason fromString(): Unknown value "$str", defaulting to unknownError');
    return CommonFailureReason.unknownError;
  }
}
