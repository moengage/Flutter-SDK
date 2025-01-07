import 'dart:convert';

import '../internal/constants.dart';
import '../internal/logger.dart';
import '../model/account_meta.dart';
import '../model/app_status.dart';
import '../model/permission_result.dart';
import '../model/permission_type.dart';
import '../model/platforms.dart';

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
  return identity is String || identity is Map<String, String>;
}
