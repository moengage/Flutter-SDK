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

/// Converts a JavaScript object to a Dart Map.
/// 
/// This function bridges JavaScript interop by extracting properties from
/// a JSObject and creating a corresponding Dart Map<String, dynamic>.
/// 
/// Returns null if [jsObject] is null or not a JSObject.
/// Throws an exception if the conversion fails due to invalid JavaScript object.
Map<String, dynamic>? convertJSObjectToMap(dynamic jsObject) {
  // Handle null input early
  if (jsObject == null) {
    return null;
  }
  
  // Initialize the result map that will hold our Dart representation
  final resultMap = <String, dynamic>{};
  
  // Only process if we have a valid JavaScript object
  if (jsObject is! JSObject) {
    return resultMap;
  }
  
  try {
    // Get the global Object constructor
    final objectConstructor = globalContext['Object'];
    if (objectConstructor == null) {
      return resultMap;
    }
    
    // Use JavaScript's Object.keys() method to get all property names
    // This returns a JSArray containing all enumerable property keys
    final keysResult = (objectConstructor as JSObject)
        .callMethod('keys'.toJS, jsObject);
    
    if (keysResult == null || keysResult is! JSArray) {
      return resultMap;
    }
    
    final keys = keysResult;
    
    // Get the number of keys (properties) in the JavaScript object
    final lengthProperty = keys.getProperty('length'.toJS);
    if (lengthProperty == null) {
      return resultMap;
    }
    
    final lengthDartified = lengthProperty.dartify();
    if (lengthDartified is! int) {
      return resultMap;
    }
    
    final length = lengthDartified;
    
    // Iterate through each key and extract the corresponding value
    for (var i = 0; i < length; i++) {
      try {
        // Get the key name and convert it to a Dart String
        final keyProperty = keys.getProperty(i.toJS);
        if (keyProperty == null) {
          continue;
        }
        
        final keyDartified = keyProperty.dartify();
        if (keyDartified == null) {
          continue;
        }
        
        final key = keyDartified.toString();
        
        // Get the value for this key and convert it to a Dart type
        // .dartify() handles the conversion from JS types to Dart types
        final valueProperty = jsObject.getProperty(key.toJS);
        final value = valueProperty.dartify();
        
        // Store the key-value pair in our result map
        resultMap[key] = value;
      } catch (e) {
        // Skip individual properties that fail to convert
        continue;
      }
    }
  } catch (e) {
    // If conversion fails completely, return empty map
    return resultMap;
  }
  
  // Return the populated map
  return resultMap;
}
