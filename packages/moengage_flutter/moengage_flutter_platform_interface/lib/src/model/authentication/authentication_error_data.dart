import '../account_meta.dart';
import '../platforms.dart';
import 'jwt_error_code.dart';

/// JWT Authentication Error Data
class AuthenticationErrorData {
  /// [AuthenticationErrorData] Constructor
  AuthenticationErrorData({
    required this.platform,
    required this.accountMeta,
    required this.code,
    required this.token,
    required this.userIdentifier,
    required this.message,
  });

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// JWT Error Code
  JwtErrorCode code;

  /// JWT Token that failed authentication
  String token;

  /// User Identifier associated with the JWT
  String userIdentifier;

  /// Error Message
  String message;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: $accountMeta'
        '\ncode: $code\nuserIdentifier: $userIdentifier\nmessage: $message\n}';
  }
}
