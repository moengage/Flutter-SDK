import 'package:flutter/services.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/geo_location.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/utils.dart';

import 'constants.dart';

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

  /// set up callback APIs for in-app events
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
        _onPushClick(pushCampaignFromMap(call.arguments));
      }
      if (call.method == callbackOnInAppClicked && _onInAppClick != null) {
        _onInAppClick(inAppCampaignFromMap(call.arguments));
      }
      if (call.method == callbackOnInAppShown && _onInAppShown != null) {
        _onInAppShown(inAppCampaignFromMap(call.arguments));
      }
      if (call.method == callbackOnInAppDismissed && _onInAppDismiss != null) {
        _onInAppDismiss(inAppCampaignFromMap(call.arguments));
      }
      if (call.method == callbackOnInAppCustomAction && _onInAppCustomAction != null) {
        _onInAppCustomAction(inAppCampaignFromMap(call.arguments));
      }
      if (call.method == callbackOnInAppSelfHandled && _onInAppSelfHandle != null) {
        _onInAppSelfHandle(inAppCampaignFromMap(call.arguments));
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
    _channel.invokeMethod(methodTrackEvent,
        getEventPayload(eventName, eventAttributes));
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameUniqueId,
            userAttrTypeGeneral, uniqueId));
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    _channel.invokeMethod(
        methodSetAlias, <String, String>{keyAlias: newUniqueId});
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameUserName,
            userAttrTypeGeneral, userName));
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameFirstName,
        userAttrTypeGeneral, firstName));
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameLastName,
        userAttrTypeGeneral, lastName));
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameEmailId,
            userAttrTypeGeneral, emailId));
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNamePhoneNum,
            userAttrTypeGeneral, phoneNumber));
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameGender,
            userAttrTypeGeneral, genderToString(gender)));
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(keyLocationAttribute,
            userAttrTypeLocation, location.toMap())
    );
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameBirtdate,
        userAttrTypeTimestamp, birthDate));
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttributeName,
        userAttrTypeGeneral, userAttributeValue));
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload( userAttributeName,
        userAttrTypeTimestamp, isoDateString));
  }

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation(String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttributeName,
            userAttrTypeLocation, location.toMap())
    );
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    _channel.invokeListMethod(methodSetAppStatus, <String, String>{
      keyAppStatus:
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

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout() {
    _channel.invokeMethod(methodLogout);
  }

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp() {
    _channel.invokeMethod(methodSelfHandledInApp);
  }

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "impression";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  /// Mark self-handled campaign as primary clicked.
  /// API to be called only when in-app is self handled
  void selfHandledPrimaryClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "primary_clicked";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "click";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "dismissed";
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  ///Set the current context for the given user.
  void setCurrentContext(List<String> contexts) {
    _channel.invokeMethod(methodSetAppContext, <String, dynamic> {
      keyContexts : contexts
    });
  }

  void resetCurrentContext() {
     _channel.invokeMethod(methodResetAppContext);
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  @Deprecated("message")
  void passPushToken(String pushToken) {
    _channel.invokeMethod(
        methodPushToken, <String, String> {
          keyPushToken: pushToken
        });
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  @Deprecated("message")
  void passPushPayload(Map<String, String> payload) {
    _channel.invokeMethod(
        methodPushPayLoad, <String, dynamic> {
          keyPushPayload: payload
        });
  }
  ///Optionally opt-out of data tracking. When data tracking is opted no event
  ///or user attribute is tracked on MoEngage Platform.
  void optOutDataTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayload(
        gdprOptOutTypeData, shouldOptOutDataTracking));
  }

  ///Optionally opt-out of push campaigns.
  ///No push campaigns will be shown once this is opted out.
  void optOutPushTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayload(
        gdprOptOutTypePush, shouldOptOutDataTracking));
  }

  ///Optionally opt-out of in-app campaigns.
  ///No in-app campaigns will be shown once this is  opted out.
  void optOutInAppTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayload(
        gdprOptOutTypeInApp, shouldOptOutDataTracking));
  }
}
