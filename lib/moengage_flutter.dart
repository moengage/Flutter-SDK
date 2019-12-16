import 'package:flutter/services.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/gender.dart';

typedef void MessageHandler(Map<String, dynamic> message);

class MoEngageFlutter {
  MethodChannel _channel = MethodChannel(channelName);

  MessageHandler _onPushClick;
  MessageHandler _onInAppClick;
  MessageHandler _onInAppShown;

  void initialise(
      {MessageHandler onPushClick,
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

  /// Tracks an event with the given attributes.
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

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_UNIQUE_ID",
      attributeValue: uniqueId
    });
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    _channel.invokeMethod(
        "setAlias", <String, String>{attributeValue: newUniqueId});
    _channel.invokeMethod('setAlias', newUniqueId);
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    _channel.invokeMethod("setUserAttribute", <String, dynamic>{
      attributeName: "USER_ATTRIBUTE_USER_NAME",
      attributeValue: userName
    });
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_FIRST_NAME",
      attributeValue: firstName
    });
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_LAST_NAME",
      attributeValue: lastName
    });
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    _channel.invokeMethod('setUserAttribute', <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_EMAIL",
      attributeValue: emailId
    });
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_MOBILE",
      attributeValue: phoneNumber
    });
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    _channel.invokeMethod("setUserAttribute", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_GENDER",
      attributeValue: gender == MoEGender.female ? "female" : "male"
    });
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod("setUserAttributeLocation", <String, dynamic>{
      attributeName: "USER_ATTRIBUTE_USER_LOCATION",
      "latitude": location.latitude,
      "longitude": location.longitude
    });
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    _channel.invokeMethod("setUserAttributeTimestamp", <String, String>{
      attributeName: "USER_ATTRIBUTE_USER_BDAY",
      attributeValue: birthDate
    });
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod("setUserAttribute", <String, dynamic>{
      attributeName: userAttributeName,
      attributeValue: userAttributeValue
    });
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod("setUserAttributeTimestamp", <String, String>{
      attributeName: userAttributeName,
      attributeValue: isoDateString
    });
  }

  /// Tracks the given location as user attribute.
  void setUserLocation(String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod("setUserAttributeLocation", <String, dynamic>{
      attributeName: userAttributeName,
      "latitude": location.latitude,
      "longitude": location.longitude
    });
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    _channel.invokeListMethod("setAppStatus", <String, String>{
      attributeValue: appStatus == MoEAppStatus.install ? "INSTALL" : "UPDATE"
    });
  }

  // Push Notification Registration
  void registerForPushNotification() {
    _channel.invokeMethod("registerForiOSPushNotification");
  }

  /// Try to show an InApp Message.
  void showInApp() {
    _channel.invokeMethod("showInApp");
  }

  /// Invalidates the existing user and session. A new user and session is created.
  void logout() {
    _channel.invokeMethod("logout");
  }

  static const String attributeValue = "attributeValue";
  static const String attributeName = "attributeName";
  static const String channelName = "flutter_moengage_plugin";
}
