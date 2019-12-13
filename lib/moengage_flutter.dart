import 'package:flutter/services.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/gender.dart';

typedef void MessageHandler(Map<String, dynamic> message);

class MoEngageFlutter {
  MethodChannel _channel = MethodChannel('flutter_moengage_plugin');

  MessageHandler _onPushClick;
  MessageHandler _onInAppClick;
  MessageHandler _onInAppShown;

  void initialise({MessageHandler onPushClick,
    MessageHandler onInAppClick,
    MessageHandler onInAppShown}) {
    _channel.setMethodCallHandler(_handler);
    _onPushClick = onPushClick;
    _onInAppClick = onInAppClick;
    _onInAppShown = onInAppShown;
    _channel.invokeMethod("initialise");
  }

  Future<dynamic> _handler(MethodCall call) async {
    print("Received callback in dart. Payload" + call.toString());
    if (call.method == "onPushClick") {
      _onPushClick(call.arguments.cast<String, dynamic>());
    }
    if (call.method == "onInAppClick") {
      _onInAppClick(call.arguments.cast<String, dynamic>());
    }
    if (call.method == "onInAppShown") {
      _onInAppShown(call.arguments.cast<String, dynamic>());
    }
  }

  // Track Event Method
  void trackEvent(String eventName, MoEProperties eventAttributes) {
    if (eventAttributes == null) {
      eventAttributes = MoEProperties();
    }
    var attributes = eventAttributes.getEventAttributeJson();
    print(attributes);
    _channel.invokeMethod("trackEvent", <String, dynamic>{
      "eventName": eventName,
      "eventAttributes": attributes
    });
  }

  // User Attribute Unique ID methods

  void setUniqueId(String uniqueId) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_UNIQUE_ID",
      attributeValue: uniqueId
    });
  }

  void setAlias(String newUniqueId) {
    _channel.invokeMethod(
        "setAlias", <String, String>{attributeValue: newUniqueId});
    _channel.invokeMethod('setAlias', newUniqueId);
  }

  // Default User Attribute methods

  void setUserName(String userName) {
    _channel.invokeMethod("setUserAttribute", <String, dynamic>{
      attributeName: "USER_ATTRIBUTE_USER_NAME",
      attributeValue: userName
    });
  }

  void setFirstName(String firstName) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_FIRST_NAME",
      attributeValue: firstName
    });
  }

  void setLastName(String lastName) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_LAST_NAME",
      attributeValue: lastName
    });
  }

  void setEmail(String emailId) {
    _channel.invokeMethod('setUserAttribute', <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_EMAIL",
      attributeValue: emailId
    });
  }

  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_MOBILE",
      attributeValue: phoneNumber
    });
  }

  void setGender(MoEGender gender) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_GENDER",
      attributeValue: gender == MoEGender.female ? "female" : "male"
    });
  }

  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod("setUserAttributeLocation", <String, dynamic>{
      attributeName: "USER_ATTRIBUTE_USER_LOCATION",
      "latitude": location.latitude,
      "longitude": location.longitude
    });
  }

  void setBirthdate(String birthdate) {
    _channel.invokeMethod("setUserAttributeTimestamp", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_BDAY",
      attributeValue: birthdate
    });
  }

  // Custom User Attributes

  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod("setUserAttribute", <String, dynamic>{
      attributeName: userAttributeName,
      attributeValue: userAttributeValue
    });
  }

  void setIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod("setUserAttributeTimestamp", <String, String>{
      attributeName: userAttributeName,
      attributeValue: isoDateString
    });
  }

  void setUserLocation(String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod("setUserAttributeLocation", <String, dynamic>{
      attributeName: userAttributeName,
      "latitude": location.latitude,
      "longitude": location.longitude
    });
  }

  void setAppStatus(MoEAppStatus appStatus) {
    _channel.invokeListMethod("setAppStatus", <String, String>{
      attributeValue: appStatus == MoEAppStatus.install ? "INSTALL" : "UPDATE"
    });
  }

  // Push Notification Registration
  void registerForPushNotification() {
    _channel.invokeMethod("registerForiOSPushNotification");
  }

  // InApp Methods
  void showInApp() {
    _channel.invokeMethod("showInApp");
  }

  // Logout Method
  void logout() {
    _channel.invokeMethod("logout");
  }

  static const String attributeValue = "attributeValue";
  static const String attributeName = "attributeName";
}
