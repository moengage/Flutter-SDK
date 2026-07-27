/// JWT Authentication Data
class AuthenticationData {
  /// [AuthenticationData] Constructor
  AuthenticationData({
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
