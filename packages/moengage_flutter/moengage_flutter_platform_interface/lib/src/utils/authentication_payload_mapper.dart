import 'dart:convert';

import '../internal/constants.dart';
import '../internal/logger.dart';
import '../model/account_meta.dart';
import '../model/authentication/authentication_data.dart';
import '../model/authentication/authentication_error_data.dart';
import '../model/platforms.dart';
import 'utils.dart';

const String _tag = '${TAG}AuthenticationPayloadMapper';

/// Parses [AuthenticationErrorData] from a native method channel callback payload.
AuthenticationErrorData? authenticationErrorFromJson(dynamic methodCallArgs) {
  try {
    final Map<String, dynamic> payload =
        json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
    final AccountMeta accountMeta =
        accountMetaFromMap(payload[keyAccountMeta] as Map<String, dynamic>);
    final Platforms platform =
        PlatformsExtension.fromString(payload[keyPlatform].toString());
    final Map<String, dynamic> data =
        payload[keyData] as Map<String, dynamic>;
    final MoEAuthenticationType authenticationType =
        MoEAuthenticationType.values.firstWhere(
      (e) => e.asString == data[keyAuthenticationType].toString().toUpperCase(),
      orElse: () => MoEAuthenticationType.jwt,
    );
    final MoEJwtErrorCode errorCode = MoEJwtErrorCodeExtension.fromString(
        castOrFallback(data[keyAuthErrorCode], ''));
    final String token = castOrFallback(data[keyToken], '');
    final String userIdentifier = castOrFallback(data[keyUserIdentifier], '');
    final String? message = data[keyAuthErrorMessage] as String?;
    return AuthenticationErrorData(
      platform: platform,
      accountMeta: accountMeta,
      authenticationType: authenticationType,
      errorCode: errorCode,
      token: token,
      userIdentifier: userIdentifier,
      message: message,
    );
  } catch (e, stackTrace) {
    Logger.e('$_tag authenticationErrorFromJson():', error: e, stackTrace: stackTrace);
  }
  return null;
}

/// Builds the payload map for [passAuthenticationDetails].
Map<String, dynamic> getAuthenticationDetailsPayload(
    String authenticationType, String token, String userIdentifier, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = <String, dynamic>{
    keyAuthenticationType: authenticationType,
    keyToken: token,
    keyUserIdentifier: userIdentifier,
  };
  return payload;
}
