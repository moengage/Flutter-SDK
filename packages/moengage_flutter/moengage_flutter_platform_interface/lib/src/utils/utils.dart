import 'dart:convert';

import 'package:flutter/services.dart';

import '../internal/constants.dart';
import '../internal/logger.dart';
import '../model/account_meta.dart';
import '../model/app_status.dart';
import '../model/authentication/authentication_data.dart';
import '../model/authentication/authentication_details_request.dart';
import '../model/authentication/authentication_error_data.dart';
import '../model/authentication/authentication_type.dart';
import '../model/authentication/jwt_error_code.dart';
import '../model/common_failure_reason.dart';
import '../model/logout_complete_data.dart';
import '../model/moe_request_failure_reason.dart';
import '../model/permission_result.dart';
import '../model/permission_type.dart';
import '../model/platforms.dart';
import '../model/unset_user_attribute_failure.dart';
import '../model/unset_user_attribute_result.dart';
import '../model/user_attribute_level.dart';

/// Log Tag for Utils.dart
const String tag = '${TAG}Utils';

/// Get Data Tracking OptOut Payload
Map<String, dynamic> getOptOutTrackingPayload(
    String type, bool shouldOptOutDataTracking, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = <String, dynamic>{
    keyType: type,
    keyState: shouldOptOutDataTracking
  };
  return payload;
}

/// Get Update SDK state Payload
Map<String, dynamic> getUpdateSdkStatePayload(
    bool shouldEnableSdk, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = getMap(keyIsSdkEnabled, shouldEnableSdk);
  return payload;
}

/// Get [Map] from Key-Value Pair
Map<String, dynamic> getMap(String key, dynamic value) {
  return <String, dynamic>{key: value};
}

/// Get Account Meta for given [appId]
Map<String, dynamic> getAccountMeta(String appId) {
  return <String, dynamic>{
    keyAccountMeta: {keyAppId: appId}
  };
}

/// Get Alias payload for given [appId]
Map<String, dynamic> getAliasPayload(String alias, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = getMap(keyAlias, alias);
  return payload;
}

/// Get App Status payload for given [appId]
Map<String, dynamic> getAppStatusPayload(MoEAppStatus appStatus, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = getMap(keyAppStatus,
      appStatus == MoEAppStatus.install ? appStatusInstall : appStatusUpdate);
  return payload;
}

/// Get InApp Context payload for given [appId]
Map<String, dynamic> getInAppContextPayload(
    List<String> contexts, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = <String, dynamic>{keyContexts: contexts};
  return payload;
}

/// Get [AccountMeta] from [Map]
AccountMeta accountMetaFromMap(Map<String, dynamic> metaPayload) {
  return AccountMeta(metaPayload[keyAppId].toString());
}

/// Convert [AccountMeta] to [Map]
Map<String, dynamic> accountMetaToMap(AccountMeta accountMeta) {
  return getAccountMeta(accountMeta.appId);
}

/// Get [PermissionResultData] from Json String
PermissionResultData permissionResultFromMap(dynamic methodCallArgs) {
  final Map<String, dynamic> permissionPayload =
      json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
  return PermissionResultData(
      PlatformsExtension.fromString(permissionPayload[keyPlatform].toString()),
      permissionPayload[keyIsPermissionGranted] as bool,
      PermissionTypeExtension.fromString(
          permissionPayload[keyPermissionType].toString()));
}

/// Get Permission Response Payload
Map<String, dynamic> getPermissionResponsePayload(
    bool isGranted, PermissionType type) {
  return {keyPermissionType: type.asString, keyIsPermissionGranted: isGranted};
}

/// Null Safe Type Casting With FallBack
T castOrFallback<T>(dynamic x, T fallback) => x is T ? x : fallback;

/// Returns Instance of [AccountMeta] from Json Payload if exists otherwise null
AccountMeta? getAccountMetaFromPayload(dynamic methodCallArgs) {
  AccountMeta? accountMeta;
  try {
    final Map<String, dynamic> payload =
        json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
    accountMeta =
        accountMetaFromMap(payload[keyAccountMeta] as Map<String, dynamic>);
  } catch (e, str) {
    Logger.e('$tag Error: getAccountMetaFromPayload() :',
        error: e, stackTrace: str);
  }
  return accountMeta;
}

/// Filters out UnSupported Types and returns valid data
/// Returns null if
dynamic filterSupportedTypes(dynamic attributeValue) {
  if (isSupportedPrimitiveType(attributeValue)) {
    return attributeValue;
  } else if (attributeValue is Iterable<dynamic>) {
    return filterIterableWithSupportedTypes(attributeValue);
  } else if (attributeValue is Map<String, dynamic>) {
    return filterMapWithSupportedTypes(attributeValue);
  }
  Logger.w(
      '$tag filterSupportedTypes() : UnSupported Value : $attributeValue ');
  return null;
}

/// Returns true if [attributeValue] is supported primitive type, otherwise false
bool isSupportedPrimitiveType(dynamic attributeValue) {
  return attributeValue is String ||
      attributeValue is int ||
      attributeValue is double ||
      attributeValue is num ||
      attributeValue is bool;
}

/// Filter List with Only Supported Data Types. Unsupported and null values will be filtered out
Iterable<dynamic> filterIterableWithSupportedTypes(Iterable<dynamic> iterable) {
  final List<dynamic> filteredList = [];
  for (final value in iterable) {
    if (isSupportedPrimitiveType(value)) {
      filteredList.add(value);
    } else if (value is Map<String, dynamic>) {
      filteredList.add(filterMapWithSupportedTypes(value));
    } else if (value is Iterable) {
      filteredList.add(filterIterableWithSupportedTypes(value));
    } else {
      Logger.w(
          '$tag filterIterableWithSupportedTypes() : Unsupported Value: $value');
    }
  }
  return filteredList;
}

/// Filter Map with Only Supported Data Types. Unsupported and  null values will be filtered out
/// [data] - Instance of [Map] containing Key-Value Pairs
/// Returns [Map] with valid data
Map<String, dynamic> filterMapWithSupportedTypes(Map<String, dynamic> data) {
  final Map<String, dynamic> filteredMap = {};
  data.forEach((key, value) {
    if (isSupportedPrimitiveType(value)) {
      filteredMap[key] = value;
    } else if (value is Map<String, dynamic>) {
      filteredMap[key] = filterMapWithSupportedTypes(value);
    } else if (value is Iterable) {
      filteredMap[key] = filterIterableWithSupportedTypes(value);
    } else {
      Logger.w(
          '$tag filterMapWithSupportedTypes() : UnSupported Value: $value for the key: $key');
    }
  });
  return filteredMap;
}

/// Return whether type of [identity] is supported or not
bool isSupportedIdentity(dynamic identity) {
  return identity is String || identity is Map<String, dynamic>;
}

/// Get [LogoutCompleteData] from Json String
LogoutCompleteData? logoutCompleteDataFromJson(dynamic methodCallArgs) {
  try {
    final Map<String, dynamic> payload =
        json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
    return LogoutCompleteData(
        platform:
            PlatformsExtension.fromString(payload[keyPlatform].toString()),
        accountMeta: accountMetaFromMap(
            payload[keyAccountMeta] as Map<String, dynamic>));
  } catch (e, stackTrace) {
    Logger.e('$tag Error: logoutCompleteDataFromJson() :',
        error: e, stackTrace: stackTrace);
  }
  return null;
}

/// Get JWT Authentication Details Payload for the given [request] and [appId]
Map<String, dynamic> getAuthenticationDetailsPayload(
    AuthenticationDetailsRequest request, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  final AuthenticationDetails data = request.data;
  if (data is JwtAuthenticationData) {
    payload[keyData] = <String, dynamic>{
      keyAuthenticationType: request.authenticationType.asString,
      keyToken: data.token,
      keyUserIdentifier: data.userIdentifier
    };
  }
  return payload;
}

/// Get [AuthenticationErrorData] from Json String
AuthenticationErrorData? authenticationErrorFromJson(dynamic methodCallArgs) {
  try {
    final Map<String, dynamic> payload =
        json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
    final Map<String, dynamic> data = payload[keyData] as Map<String, dynamic>;
    return AuthenticationErrorData(
        platform:
            PlatformsExtension.fromString(payload[keyPlatform].toString()),
        accountMeta:
            accountMetaFromMap(payload[keyAccountMeta] as Map<String, dynamic>),
        authenticationType: AuthenticationTypeExtension.fromString(
            data[keyAuthenticationType].toString()),
        data: JwtAuthenticationErrorData(
            code: JwtErrorCodeExtension.fromString(
                data[keyAuthenticationErrorCode].toString()),
            token: data[keyToken].toString(),
            userIdentifier: data[keyUserIdentifier].toString(),
            message: data[keyAuthenticationErrorMessage].toString()));
  } catch (e, stackTrace) {
    Logger.e('$tag Error: authenticationErrorFromJson() :',
        error: e, stackTrace: stackTrace);
  }
  return null;
}

/// Get Firebase Installation Id Payload for the given [installationId] and [appId]
Map<String, dynamic> getFirebaseInstallationIdPayload(
    String installationId, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {keyInstallationId: installationId};
  return payload;
}

/// Get the first value in [values] whose [MoERequestFailureReason.value] matches [str].
///
/// Returns `null` when none match, rather than defaulting to a fallback reason — shared by the
/// common failure reason enum and every feature-specific failure reason enum so the "match by
/// wire value" loop isn't reimplemented per enum.
T? tryFromValue<T extends MoERequestFailureReason>(List<T> values, String str) {
  for (final value in values) {
    if (value.value == str) {
      return value;
    }
  }
  return null;
}

/// Get unsetUserAttribute payload for the given [attributeName], [attributeLevel] and [appId].
Map<String, dynamic> getUnsetUserAttributePayload(
    String attributeName, UserAttributeLevel attributeLevel, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyAttributeName: attributeName,
    keyAttributeLevel: attributeLevel.value,
  };
  return payload;
}

/// Deserialize the unsetUserAttribute response.
///
/// The native bridge always resolves successfully - the response is a single JSON shape for both
/// outcomes, with `data.isUnsetSuccess` distinguishing them, per the contract (the same convention
/// the React Native bridge uses for this call). Returns the [UnsetUserAttributeResult] when
/// `isUnsetSuccess` is true. Throws [UnsetUserAttributeFailure], built from the embedded
/// `data.failure.{reason,message}`, when it is false.
UnsetUserAttributeResult unsetUserAttributeResultFromJson(dynamic methodCallResult) {
  final Map<String, dynamic> response =
      json.decode(methodCallResult.toString()) as Map<String, dynamic>;
  final Map<String, dynamic> data = response[keyData] as Map<String, dynamic>;
  if (data[keyIsUnsetSuccess] != true) {
    final Map<String, dynamic> failure =
        data[keyFailure] as Map<String, dynamic>? ?? const {};
    throw UnsetUserAttributeFailure(
      failureReason:
          CommonFailureReason.fromString(failure[keyFailureReason]?.toString() ?? ''),
      message: failure[keyFailureMessage]?.toString() ?? '',
    );
  }
  return UnsetUserAttributeResult(
    attributeName: data[keyAttributeName].toString(),
    attributeLevel: UserAttributeLevel.fromString(data[keyAttributeLevel].toString()),
  );
}

/// Convert an error raised while unsetting a user attribute into an [UnsetUserAttributeFailure].
///
/// [unsetUserAttributeResultFromJson] already throws a fully-formed [UnsetUserAttributeFailure]
/// for a native-side failure, so it passes through unchanged here. This only handles a genuinely
/// exceptional bridge-level error - e.g. a malformed method-channel call - reading
/// [PlatformException.code] when present, the same fallback convention recommendations uses.
UnsetUserAttributeFailure toUnsetUserAttributeFailure(Object error) {
  if (error is UnsetUserAttributeFailure) {
    return error;
  }
  if (error is PlatformException) {
    return UnsetUserAttributeFailure(
      failureReason: CommonFailureReason.fromString(error.code),
      message: error.message ?? '',
    );
  }
  return UnsetUserAttributeFailure(
    failureReason: CommonFailureReason.unknownError,
    message: error.toString(),
  );
}
