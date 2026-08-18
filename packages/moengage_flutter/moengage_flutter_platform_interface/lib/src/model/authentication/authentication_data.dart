/// Base class for the scheme specific authentication payload carried by
/// [AuthenticationDetailsRequest]. Extend this to add authentication schemes
/// beyond [JwtAuthenticationData] in the future.
sealed class AuthenticationDetails {
  /// Const constructor for [AuthenticationDetails]
  const AuthenticationDetails();
}

/// JWT Authentication Data
final class JwtAuthenticationData extends AuthenticationDetails {
  /// [JwtAuthenticationData] Constructor
  JwtAuthenticationData({
    required this.token,
    required this.userIdentifier,
  });

  /// JWT Token
  String token;

  /// User Identifier the JWT Token was generated for
  String userIdentifier;

  @override
  String toString() {
    return '{token: $token\nuserIdentifier: $userIdentifier}';
  }
}
