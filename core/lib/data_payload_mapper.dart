import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/utils.dart';

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
