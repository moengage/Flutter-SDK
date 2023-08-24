import 'dart:convert';

import '../internal/constants.dart';
import '../model/account_meta.dart';
import '../model/app_status.dart';
import '../model/permission_result.dart';
import '../model/permission_type.dart';
import '../model/platforms.dart';

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
