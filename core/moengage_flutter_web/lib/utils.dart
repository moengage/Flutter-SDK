// ignore_for_file: public_member_api_docs
import 'dart:js' as js;
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'extensions.dart';

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

dynamic recursivelyJsifyObjects(List<dynamic> list) {
  final usrAttr = list.map((e) {
    if (e is Map<String, dynamic>) {
      // element was an object, Jsify it
      return js.JsObject.jsify(e);
    } else if (e is List<dynamic>) {
      // nested list
      return recursivelyJsifyObjects(e);
    }
    return e;
  });
  return js.JsArray.from(usrAttr);
}

dynamic getUserAttributeValuePayload(dynamic userAttributeValue) {
  if (userAttributeValue is List<dynamic>) {
    return recursivelyJsifyObjects(userAttributeValue);
  }
  if (userAttributeValue is Map<String, dynamic>) {
    return js.JsObject.jsify(userAttributeValue);
  }
  return userAttributeValue;
}
