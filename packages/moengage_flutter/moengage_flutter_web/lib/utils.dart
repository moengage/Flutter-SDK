// ignore_for_file: public_member_api_docs
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
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
      return e.jsify();
    } else if (e is List<dynamic>) {
      // nested list
      return recursivelyJsifyObjects(e);
    }
    return e;
  });
  return usrAttr.toList().jsify();
}

dynamic getUserAttributeValuePayload(dynamic userAttributeValue) {
  if (userAttributeValue is List<dynamic>) {
    return recursivelyJsifyObjects(userAttributeValue);
  }
  if (userAttributeValue is Map<String, dynamic>) {
    return userAttributeValue.jsify();
  }
  return userAttributeValue;
}

dynamic getIdentifyUserPayload(dynamic identities) {
  if (identities is Map<String, String>) {
    return identities.jsify();
  }
  return identities;
}

Map<String, String>? convertJSObjectToMap(dynamic jsObject) {
  if (jsObject == null) {
    return null;
  }
  
  final resultMap = <String, String>{};
  if (jsObject is JSObject) {
    final keys = (globalContext['Object'] as JSObject)
        .callMethod('keys'.toJS, jsObject) as JSArray;
    
    final length = keys.getProperty('length'.toJS).dartify() as int;
    for (var i = 0; i < length; i++) {
      final key = keys.getProperty(i.toJS).dartify().toString();
      final value = jsObject.getProperty(key.toJS).dartify().toString();
      resultMap[key] = value;
    }
  }
  return resultMap;
}
