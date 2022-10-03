import 'dart:io';

import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/model/account_meta.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/permission_result.dart';
import 'package:moengage_flutter/model/permission_type.dart';
import 'package:moengage_flutter/model/platforms.dart';

Map<String, dynamic> getOptOutTrackingPayload(
    String type, bool shouldOptOutDataTracking, String appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {keyType: type, keyState: shouldOptOutDataTracking};
  return payload;
}

Map<String, dynamic> getUpdateSdkStatePayload(
    bool shouldEnableSdk, String appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = getMap(keyIsSdkEnabled, shouldEnableSdk);
  return payload;
}

Map<String, dynamic> getMap(String key, dynamic value) {
  return <String, dynamic>{key: value};
}

Map<String, dynamic> getAccountMeta(String appId) {
  return {
    keyAccountMeta: {keyAppId: appId}
  };
}

Map<String, dynamic> getAliasPayload(String alias, String appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = getMap(keyAlias, alias);
  return payload;
}

Map<String, dynamic> getAppStatusPayload(MoEAppStatus appStatus, String appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = getMap(keyAppStatus,
      appStatus == MoEAppStatus.install ? appStatusInstall : appStatusUpdate);
  return payload;
}

Map<String, dynamic> getInAppContextPayload(
    List<String> contexts, String appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = <String, dynamic>{keyContexts: contexts};
  return payload;
}

AccountMeta accountMetaFromMap(Map<String, dynamic> metaPayload) {
  return AccountMeta(metaPayload[keyAppId]);
}

Map<String, dynamic> accountMetaToMap(AccountMeta accountMeta) {
  return getAccountMeta(accountMeta.appId);
}

PermissionResultData permissionResultFromMap(
    Map<String, dynamic> permissionPayload) {
  return PermissionResultData(
      PlatformsExtension.fromString(permissionPayload[keyPlatform]),
      permissionPayload[keyIsPermissionGranted],
      PermissionTypeExtension.fromString(keyPermissionType));
}

Map<String, dynamic> getPermissionResponsePayload(
    bool isGranted, PermissionType type) {
  return {keyPermissionType: type.asString, keyIsPermissionGranted: isGranted};
}
