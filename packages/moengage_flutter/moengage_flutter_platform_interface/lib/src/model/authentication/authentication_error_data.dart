import '../account_meta.dart';
import '../platforms.dart';
import 'authentication_data.dart';

/// JWT error codes returned by the native SDK
enum MoEJwtErrorCode {
  timeConstraintFailure,
  decryptionFailed,
  headerTypeIncompatible,
  payloadContentMissing,
  invalidSignature,
  identifierMismatch,
  unknown,
  tokenNotAvailable,
}

/// Extension on [MoEJwtErrorCode]
extension MoEJwtErrorCodeExtension on MoEJwtErrorCode {
  static MoEJwtErrorCode fromString(String value) {
    switch (value.toUpperCase()) {
      case 'TIME_CONSTRAINT_FAILURE':
        return MoEJwtErrorCode.timeConstraintFailure;
      case 'DECRYPTION_FAILED':
        return MoEJwtErrorCode.decryptionFailed;
      case 'HEADER_TYPE_INCOMPATIBLE':
        return MoEJwtErrorCode.headerTypeIncompatible;
      case 'PAYLOAD_CONTENT_MISSING':
        return MoEJwtErrorCode.payloadContentMissing;
      case 'INVALID_SIGNATURE':
        return MoEJwtErrorCode.invalidSignature;
      case 'IDENTIFIER_MISMATCH':
        return MoEJwtErrorCode.identifierMismatch;
      case 'TOKEN_NOT_AVAILABLE':
        return MoEJwtErrorCode.tokenNotAvailable;
      case 'UNKNOWN':
      default:
        return MoEJwtErrorCode.unknown;
    }
  }
}

/// Authentication error data received from native SDK
class AuthenticationErrorData {
  AuthenticationErrorData({
    required this.platform,
    required this.accountMeta,
    required this.authenticationType,
    required this.errorCode,
    required this.token,
    required this.userIdentifier,
    this.message,
  });

  /// Platform that emitted the error
  final Platforms platform;

  /// Account meta containing the app ID
  final AccountMeta accountMeta;

  /// Authentication type (e.g. JWT)
  final MoEAuthenticationType authenticationType;

  /// JWT-specific error code
  final MoEJwtErrorCode errorCode;

  /// The token that caused the error
  final String token;

  /// User identifier associated with the error
  final String userIdentifier;

  /// Optional error message
  final String? message;

  @override
  String toString() {
    return 'AuthenticationErrorData(platform: $platform, accountMeta: $accountMeta, '
        'authenticationType: $authenticationType, errorCode: $errorCode, '
        'token: $token, userIdentifier: $userIdentifier, message: $message)';
  }
}
