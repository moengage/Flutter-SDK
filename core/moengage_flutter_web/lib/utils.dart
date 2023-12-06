// ignore_for_file: public_member_api_docs
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'extensions.dart';
import 'dart:js' as js;

Map<String, dynamic> getEventPayloadWeb(
  String eventName,
  MoEProperties eventAttributes,
) {
  final Map<String, dynamic> eventPayload =
      eventAttributes.getNormalizedEventAttributeJson();
  eventPayload[keyEventName] = eventName;
  return eventPayload;
}

Map<String, dynamic> getUserAttributePayload(
  String attributeName,
  String attributeType,
  dynamic attributeValue,
) {
  if (attributeType == userAttrTypeLocation) {
    return <String, dynamic>{
      keyAttributeName: attributeName,
      keyAttributeType: attributeType,
      keyLocationAttribute: attributeValue
    };
  } else {
    return <String, dynamic>{
      keyAttributeName: attributeName,
      keyAttributeType: attributeType,
      keyAttributeValue: attributeValue
    };
  }
}

dynamic getUserAttributeValuePayload(dynamic userAttributeValue) {
  if (userAttributeValue is List<dynamic>) {
    return js.JsArray.from(userAttributeValue);
  }
  return userAttributeValue;
}
