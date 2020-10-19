import 'package:flutter/services.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/user_attribute_type.dart';
import 'package:moengage_flutter/utils.dart';

typedef void PushCallbackHandler(PushCampaign pushCampaign);
typedef void InAppCallbackHandler(InAppCampaign inAppCampaign);

class MoEngageFlutter {
  MethodChannel _channel = MethodChannel(channelName);

  PushCallbackHandler _onPushClick;
  InAppCallbackHandler _onInAppClick;
  InAppCallbackHandler _onInAppShown;
  InAppCallbackHandler _onInAppDismiss;
  InAppCallbackHandler _onInAppCustomAction;
  InAppCallbackHandler _onInAppSelfHandle;


  void initialise() {
    _channel.setMethodCallHandler(_handler);
    _channel.invokeMethod(methodInitialise);
  }

  void setUpPushCallbacks(PushCallbackHandler onPushClick) {
    _onPushClick = onPushClick;
  }

  void setUpInAppCallbacks(
      {InAppCallbackHandler onInAppClick,
        InAppCallbackHandler onInAppShown,
        InAppCallbackHandler onInAppDismiss,
        InAppCallbackHandler onInAppCustomAction,
        InAppCallbackHandler onInAppSelfHandle}) {
    _onInAppClick = onInAppClick;
    _onInAppShown = onInAppShown;
    _onInAppDismiss = onInAppDismiss;
    _onInAppCustomAction = onInAppCustomAction;
    _onInAppSelfHandle = onInAppSelfHandle;
  }

  Future<dynamic> _handler(MethodCall call) async {
    print("Received callback in dart. Payload" + call.toString());
    try {
      if (call.method == callbackOnPushClick && _onPushClick != null) {
        _onPushClick(pushCampaignFromMap(call.arguments.cast<String, dynamic>()));
      }
      if (call.method == callbackOnInAppClicked && _onInAppClick != null) {
        _onInAppClick(inAppCampaignFromMap(call.arguments.cast<String, dynamic>()));
      }
      if (call.method == callbackOnInAppShown && _onInAppShown != null) {
        _onInAppShown(inAppCampaignFromMap(call.arguments.cast<String, dynamic>()));
      }
      if (call.method == callbackOnInAppDismissed && _onInAppDismiss != null) {
        _onInAppDismiss(inAppCampaignFromMap(call.arguments.cast<String, dynamic>()));
      }
      if (call.method == callbackOnInAppCustomAction && _onInAppCustomAction != null) {
        _onInAppCustomAction(inAppCampaignFromMap(call.arguments.cast<String, dynamic>()));
      }
      if (call.method == callbackOnInAppSelfHandled && _onInAppSelfHandle != null) {
        _onInAppSelfHandle(inAppCampaignFromMap(call.arguments.cast<String, dynamic>()));
      }
    } catch (exception) {
      print(exception);
    }
  }

  /// Enables MoEngage logs.
  void enableSDKLogs() {
    _channel.invokeMethod(methodEnableSDKLogs);
  }

  /// Tracks an event with the given attributes.
  void trackEvent(String eventName, MoEProperties eventAttributes) {
    _channel.invokeMethod(methodTrackEvent, getEventPayload(eventName, eventAttributes));
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameUniqueId,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: uniqueId
    });
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    _channel.invokeMethod(
        methodSetAlias, <String, String>{keyAlias: newUniqueId});
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    _channel.invokeMethod(methodSetUserAttribute, <String, dynamic>{
      keyAttributeName: userAttrNameUserName,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: userName
    });
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameFirstName,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: firstName
    });
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameLastName,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: lastName
    });
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameEmailId,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: emailId
    });
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNamePhoneNum,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: phoneNumber
    });
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    _channel.invokeMethod(methodSetUserAttribute, <String, String>{
      keyAttributeName: userAttrNameGender,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: moEGenderToString(gender)
    });
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttributeLocation,
        getLocationPayload(keyLocationAttribute, location)
    );
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    _channel.invokeMethod(methodSetUserAttributeTimestamp, <String, String>{
      keyAttributeName: userAttrNameBirtdate,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.timestamp),
      keyAttributeValue: birthDate
    });
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod(methodSetUserAttribute, <String, dynamic>{
      keyAttributeName: userAttributeName,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.general),
      keyAttributeValue: userAttributeValue
    });
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod(methodSetUserAttributeTimestamp, <String, String>{
      keyAttributeName: userAttributeName,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.timestamp),
      keyAttributeValue: isoDateString
    });
  }

  /// Tracks the given location as user attribute.
  void setUserLocation(String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttributeLocation,
        getLocationPayload(userAttributeName, location)
    );
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
  }

  void getSelfHandledInApp() {
    _channel.invokeMethod(methodLogout);
  }

  void selfHandledShown(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toJSON();
    payload[keyAttributeType] = "impression";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  void selfHandledPrimaryClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toJSON();
    payload[keyAttributeType] = "primary_clicked";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  void selfHandledClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toJSON();
    payload[keyAttributeType] = "click";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  void selfHandledDismissed(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toJSON();
    payload[keyAttributeType] = "dismissed";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  void setCurrentContext(List<String> contexts) {
    _channel.invokeMethod(methodSetAppContext, <String, dynamic> {
      "contexts": contexts
    });
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushToken(String pushToken) {
    _channel.invokeMethod(
        methodPushToken, <String, String> {
          keyPushToken: pushToken
        });
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushPayload(Map<String, String> payload) {
    _channel.invokeMethod(
        methodPushPayLoad, <String, dynamic> {
          keyPushPayload: payload
        });
  }

  void optOutDataTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutDataTracking,  <String, dynamic> {
      keyAttributeType: gdprOptOutTypeData,
      keyState: shouldOptOutDataTracking
    });
  }

  void optOutPushTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutDataTracking,  <String, dynamic> {
      keyAttributeType: gdprOptOutTypePush,
      keyState: shouldOptOutDataTracking
    });
  }

  void optOutInAppTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutDataTracking,  <String, dynamic> {
      keyAttributeType: gdprOptOutTypeInApp,
      keyState: shouldOptOutDataTracking
    });
  }
}
