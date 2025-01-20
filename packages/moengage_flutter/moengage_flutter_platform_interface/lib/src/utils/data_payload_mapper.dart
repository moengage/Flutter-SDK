import '../internal/constants.dart';
import '../model/inapp/nudge_position.dart';
import '../model/properties.dart';
import 'utils.dart';

/// Get Event Tracking Payload
Map<String, dynamic> getEventPayload(
    String eventName, MoEProperties eventAttributes, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  final Map<String, dynamic> data = eventAttributes.getEventAttributeJson();
  data[keyEventName] = eventName;
  payload[keyData] = data;
  return payload;
}

/// Get User Attribute Payload
Map<String, dynamic> getUserAttributePayload(String attributeName,
    String attributeType, dynamic attributeValue, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  Map<String, dynamic> data;
  if (attributeType == userAttrTypeLocation) {
    data = <String, dynamic>{
      keyAttributeName: attributeName,
      keyType: attributeType,
      keyLocationAttribute: attributeValue
    };
  } else {
    data = <String, dynamic>{
      keyAttributeName: attributeName,
      keyType: attributeType,
      keyAttributeValue: attributeValue
    };
  }
  payload[keyData] = data;
  return payload;
}

/// Get Show Nudge Json Payload provided  the [position] and [appId]
Map<String, dynamic> getShowNudgeJsonPayload(
    MoEngageNudgePosition position, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {keyNudgePosition: position.name};
  return payload;
}

/// Get identifyUser Payload with params [identity] and [appId]
Map<String, dynamic> getIdentifyUserPayload(dynamic identity, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  if (identity is String) {
    payload[keyData] = {
      keyUserIdentity: {keyUniqueUserIdentity: identity}
    };
  } else if (identity is Map<String, String>) {
    payload[keyData] = {keyUserIdentity: identity};
  }

  return payload;
}
