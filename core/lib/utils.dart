import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/model/account_meta.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/properties.dart';

Map<String, dynamic> getEventPayload(
    String eventName, MoEProperties eventAttributes, appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  Map<String, dynamic> data = eventAttributes.getEventAttributeJson();
  data[keyEventName] = eventName;
  payload[keyData] = data;
  return payload;
}

Map<String, dynamic> getUserAttributePayload(String attributeName,
    String attributeType, dynamic attributeValue, String appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  Map<String, dynamic> data;
  if (attributeType == userAttrTypeLocation) {
    data = <String, dynamic> {
      keyAttributeName: attributeName,
      keyAttributeType: attributeType,
      keyLocationAttribute: attributeValue
    };
  } else {
    data = <String, dynamic> {
      keyAttributeName: attributeName,
      keyAttributeType: attributeType,
      keyAttributeValue: attributeValue
    };
  }
  payload[keyData] = data;
  return payload;
}

Map<String, dynamic> getOptOutTrackingPayload(
    String type, bool shouldOptOutDataTracking, String appId) {
  Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = getMap(type, shouldOptOutDataTracking);
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
