import 'package:flutter/services.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/constants.dart';
import 'dart:js' as js;

typedef void MessageHandler(Map<String, dynamic> message);

class MoEngageFlutter {
  MethodChannel _channel = MethodChannel(channelName);

  MessageHandler _onPushClick;
  MessageHandler _onInAppClick;
  MessageHandler _onInAppShown;

  var moengage = js.JsObject.fromBrowserObject(js.context['Moengage']);


  void initialise() {
    _channel.setMethodCallHandler(_handler);
    _channel.invokeMethod(methodInitialise);
  }

  void setUpPushCallbacks(MessageHandler onPushClick) {
    _onPushClick = onPushClick;
  }

  void setUpInAppCallbacks(
      {MessageHandler onInAppClick, MessageHandler onInAppShown}) {
    _onInAppClick = onInAppClick;
    _onInAppShown = onInAppShown;
  }

  Future<dynamic> _handler(MethodCall call) async {
    print("Received callback in dart. Payload" + call.toString());
    if (call.method == callbackOnPushClick && _onPushClick != null) {
      _onPushClick(call.arguments.cast<String, dynamic>());
    }
    if (call.method == callbackOnInAppClicked && _onInAppClick != null) {
      _onInAppClick(call.arguments.cast<String, dynamic>());
    }
    if (call.method == callbackOnInAppShown && _onInAppShown != null) {
      _onInAppShown(call.arguments.cast<String, dynamic>());
    }
  }

  /// Tracks an event with the given attributes.
  void trackEvent(String eventName, MoEProperties eventAttributes) {
    if (eventAttributes == null) {
      eventAttributes = MoEProperties();
    }
    var attributes = eventAttributes.getEventAttributeJson();
    
    _channel.invokeMethod(methodTrackEvent, <String, dynamic>{
      keyEventName: eventName,
      keyEventAttributes: attributes
    });
   
    moengage.callMethod('track_event', [eventName, js.JsObject.jsify(attributes)]);
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameUniqueId,
      keyAttributeValue: uniqueId
    });
    moengage.callMethod('add_unique_user_id', [uniqueId]);
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    _channel.invokeMethod(
        methodSetAlias, <String, String>{keyAttributeValue: newUniqueId});
    moengage.callMethod('update_unique_user_id', [newUniqueId]);
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    _channel.invokeMethod(methodSetUserAttribute, <String, dynamic>{
      keyAttributeName: userAttrNameUserName,
      keyAttributeValue: userName
    });
    moengage.callMethod('add_user_name', [userName]);
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameFirstName,
      keyAttributeValue: firstName
    });
    moengage.callMethod('add_first_name', [firstName]);
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameLastName,
      keyAttributeValue: lastName
    });
    moengage.callMethod('add_last_name', [lastName]);
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameEmailId,
      keyAttributeValue: emailId
    });
    moengage.callMethod('add_email', [emailId]);
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNamePhoneNum,
      keyAttributeValue: phoneNumber
    });
    moengage.callMethod('add_mobile', [phoneNumber]);
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameGender,
      keyAttributeValue: gender == MoEGender.female ? genderFemale : genderMale
    });
    moengage.callMethod('add_gender', [gender]);
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttributeLocation, <String, dynamic>{
      keyAttributeName: userAttrNameLocation,
      keyAttrLatitudeName: location.latitude,
      keyAttrLongitudeName: location.longitude
    });
    // TODO: add location for web sdk
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    _channel.invokeMethod(methodSetUserAttributeTimestamp, <String, String>{
      keyAttributeName: userAttrNameBirtdate,
      keyAttributeValue: birthDate
    });
    // TODO: check date format
    moengage.callMethod('add_birthday', [birthDate]);
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod(methodSetUserAttribute, <String, dynamic>{
      keyAttributeName: userAttributeName,
      keyAttributeValue: userAttributeValue
    });
    moengage.callMethod('add_user_attribute', [userAttributeName, userAttributeValue]);
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod(methodSetUserAttributeTimestamp, <String, String>{
      keyAttributeName: userAttributeName,
      keyAttributeValue: isoDateString
    });
    // TODO: convert date
    moengage.callMethod('add_user_attribute', [userAttributeName, isoDateString]);
  }

  /// Tracks the given location as user attribute.
  void setUserLocation(String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttributeLocation, <String, dynamic>{
      keyAttributeName: userAttributeName,
      keyAttrLatitudeName: location.latitude,
      keyAttrLongitudeName: location.longitude
    });
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    _channel.invokeListMethod(methodSetAppStatus, <String, String>{
      keyAttributeValue:
          appStatus == MoEAppStatus.install ? appStatusInstall : appStatusUpdate
    });
  }

  // Push Notification Registration
  void registerForPushNotification() {
    _channel.invokeMethod(methodRegisterForiOSPush);
  }

  /// Try to show an InApp Message.
  void showInApp() {
    _channel.invokeMethod(methodShowInApp);
  }

  /// Invalidates the existing user and session. A new user and session is created.
  void logout() {
    _channel.invokeMethod(methodLogout);
    moengage.callMethod('destroy_session');
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushToken(String pushToken) {
    _channel.invokeMethod(
        methodPushToken, <String, String>{keyPushToken: pushToken});
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushPayload(Map<String, String> payload) {
    _channel.invokeMethod(
        methodPushPayLoad, <String, dynamic>{keyPushPayload: payload});
  }
}
