import '../account_meta.dart';
import '../platforms.dart';
import 'authentication_type.dart';
import 'jwt_error_code.dart';

/// Base class for the scheme specific authentication error details carried by
/// [AuthenticationErrorData]. Extend this to add authentication schemes
/// beyond [JwtAuthenticationErrorData] in the future.
sealed class AuthenticationErrorDetails {
  /// Const constructor for [AuthenticationErrorDetails]
  const AuthenticationErrorDetails();
}

/// JWT Authentication Error Data
final class JwtAuthenticationErrorData extends AuthenticationErrorDetails {
  /// [JwtAuthenticationErrorData] Constructor
  JwtAuthenticationErrorData({
    required this.code,
    required this.token,
    required this.userIdentifier,
    required this.message,
  });

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
    return '{code: $code\ntoken: $token\nuserIdentifier: $userIdentifier'
        '\nmessage: $message}';
  }
}

/// Authentication Error Data delivered via [AuthenticationErrorCallbackHandler]
/// when the SDK fails to authenticate a network request.
class AuthenticationErrorData {
  /// [AuthenticationErrorData] Constructor
  AuthenticationErrorData({
    required this.platform,
    required this.accountMeta,
    required this.authenticationType,
    required this.data,
  });

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// Authentication scheme that failed
  AuthenticationType authenticationType;

  /// Scheme specific error details, instance of [AuthenticationErrorDetails]
  AuthenticationErrorDetails data;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: $accountMeta'
        '\nauthenticationType: $authenticationType\ndata: $data\n}';
  }
}
