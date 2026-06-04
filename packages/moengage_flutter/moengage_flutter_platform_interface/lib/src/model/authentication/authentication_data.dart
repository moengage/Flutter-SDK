/// Supported authentication types
enum MoEAuthenticationType {
  /// JSON Web Token authentication
  jwt,
}

/// Extension on [MoEAuthenticationType]
extension MoEAuthenticationTypeExtension on MoEAuthenticationType {
  String get asString {
    switch (this) {
      case MoEAuthenticationType.jwt:
        return 'JWT';
    }
  }
}
