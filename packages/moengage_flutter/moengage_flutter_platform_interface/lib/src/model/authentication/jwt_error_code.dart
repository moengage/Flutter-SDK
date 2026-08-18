/// JWT Authentication Error Code
enum JwtErrorCode {
  /// The JWT was generated/validated outside of the allowed time window.
  timeConstraintFailure,

  /// The JWT could not be decrypted.
  decryptionFailed,

  /// The JWT header type is incompatible.
  headerTypeIncompatible,

  /// The JWT payload is missing required content.
  payloadContentMissing,

  /// The JWT signature is invalid.
  invalidSignature,

  /// The identifier in the JWT does not match the current user.
  identifierMismatch,

  /// An unknown error occurred.
  unknown,

  /// No JWT token was available.
  tokenNotAvailable
}

/// Extension for [JwtErrorCode]
extension JwtErrorCodeExtension on JwtErrorCode {
  /// Get [JwtErrorCode] instance from String
  static JwtErrorCode fromString(String code) {
    switch (code) {
      case _codeTimeConstraintFailure:
        return JwtErrorCode.timeConstraintFailure;
      case _codeDecryptionFailed:
        return JwtErrorCode.decryptionFailed;
      case _codeHeaderTypeIncompatible:
        return JwtErrorCode.headerTypeIncompatible;
      case _codePayloadContentMissing:
        return JwtErrorCode.payloadContentMissing;
      case _codeInvalidSignature:
        return JwtErrorCode.invalidSignature;
      case _codeIdentifierMismatch:
        return JwtErrorCode.identifierMismatch;
      case _codeTokenNotAvailable:
        return JwtErrorCode.tokenNotAvailable;
      case _codeUnknown:
      default:
        return JwtErrorCode.unknown;
    }
  }
}

const String _codeTimeConstraintFailure = 'TIME_CONSTRAINT_FAILURE';
const String _codeDecryptionFailed = 'DECRYPTION_FAILED';
const String _codeHeaderTypeIncompatible = 'HEADER_TYPE_INCOMPATIBLE';
const String _codePayloadContentMissing = 'PAYLOAD_CONTENT_MISSING';
const String _codeInvalidSignature = 'INVALID_SIGNATURE';
const String _codeIdentifierMismatch = 'IDENTIFIER_MISMATCH';
const String _codeUnknown = 'UNKNOWN';
const String _codeTokenNotAvailable = 'TOKEN_NOT_AVAILABLE';
