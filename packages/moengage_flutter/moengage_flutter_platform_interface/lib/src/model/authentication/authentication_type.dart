/// Type of authentication used to authenticate the SDK's network requests.
enum AuthenticationType {
  /// Authentication using JWT (JSON Web Token).
  jwt
}

/// Extension for [AuthenticationType]
extension AuthenticationTypeExtension on AuthenticationType {
  /// Get the wire representation of [AuthenticationType]
  String get asString {
    switch (this) {
      case AuthenticationType.jwt:
        return _typeJwt;
    }
  }

  /// Get [AuthenticationType] instance from String
  static AuthenticationType fromString(String type) {
    switch (type) {
      case _typeJwt:
      default:
        return AuthenticationType.jwt;
    }
  }
}

const String _typeJwt = 'JWT';
