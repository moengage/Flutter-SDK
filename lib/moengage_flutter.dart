import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/moe_android.dart';
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
  MoEAndroid _moEAndroid;

  PushCallbackHandler _onPushClick;
  InAppCallbackHandler _onInAppClick;
  InAppCallbackHandler _onInAppShown;
  InAppCallbackHandler _onInAppDismiss;
  InAppCallbackHandler _onInAppCustomAction;
  InAppCallbackHandler _onInAppSelfHandle;

  void initialise() {
    _channel.setMethodCallHandler(_handler);
    _channel.invokeMethod(methodInitialise);
    _moEAndroid = MoEAndroid(_channel);
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
    if (Platform.isAndroid) {
      _moEAndroid.enableSDKLogs();
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodEnableSDKLogs);
    }
  }

  /// Tracks an event with the given attributes.
  void trackEvent(String eventName, MoEProperties eventAttributes) {
    if (Platform.isAndroid) {
      _moEAndroid.trackEvent(eventName, eventAttributes);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodTrackEvent,
          getEventPayload(eventName, eventAttributes));
    }
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    if (Platform.isAndroid) {
      _moEAndroid.setUniqueId(uniqueId);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNameUniqueId,
              userAttrTypeGeneral, uniqueId));
    }
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    if (Platform.isAndroid) {
      _moEAndroid.setAlias(newUniqueId);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(
          methodSetAlias, getMap(keyAlias, newUniqueId));
    }
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    if (Platform.isAndroid) {

    } else if (Platform.isIOS) {

    }
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayload(userAttrNameUserName,
            userAttrTypeGeneral, userName));
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    if (Platform.isAndroid) {
      _moEAndroid.setFirstName(firstName);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNameFirstName,
              userAttrTypeGeneral, firstName));
    }
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    if (Platform.isAndroid) {
      _moEAndroid.setLastName(lastName);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNameLastName,
              userAttrTypeGeneral, lastName));
    }
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    if (Platform.isAndroid) {
      _moEAndroid.setEmail(emailId);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNameEmailId,
              userAttrTypeGeneral, emailId));
    }
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    if (Platform.isAndroid) {
      _moEAndroid.setPhoneNumber(phoneNumber);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNamePhoneNum,
              userAttrTypeGeneral, phoneNumber));
    }
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    if (Platform.isAndroid) {
      _moEAndroid.setGender(gender);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNameGender,
              userAttrTypeGeneral, genderToString(gender)));
    }
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    if (Platform.isAndroid) {
      _moEAndroid.setLocation(location);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNameLocation,
              userAttrTypeLocation, location.toMap())
      );
    }
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    if (Platform.isAndroid) {
      _moEAndroid.setBirthDate(birthDate);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttrNameBirtdate,
              userAttrTypeTimestamp, birthDate));
    }
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    if (Platform.isAndroid) {
      _moEAndroid.setUserAttribute(userAttributeName, userAttributeValue);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttributeName,
              userAttrTypeGeneral, userAttributeValue));
    }
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    if (Platform.isAndroid) {
      _moEAndroid.setUserAttributeIsoDate(userAttributeName, isoDateString);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttributeName,
              userAttrTypeTimestamp, isoDateString));
    }
  }

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation(String userAttributeName, MoEGeoLocation location) {
    if (Platform.isAndroid) {
      _moEAndroid.setUserAttributeLocation(userAttributeName, location);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayload(userAttributeName,
              userAttrTypeLocation, location.toMap()));
    }
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    if (Platform.isAndroid) {
      _moEAndroid.setAppStatus(appStatus);
    } else if (Platform.isIOS) {
      _channel.invokeListMethod(methodSetAppStatus, <String, String>{
        keyAppStatus:
        appStatus == MoEAppStatus.install ? appStatusInstall : appStatusUpdate
      });
    }
  }

  // Push Notification Registration
  void registerForPushNotification() {
    _channel.invokeMethod(methodRegisterForiOSPush);
  }

  /// Try to show an InApp Message.
  void showInApp() {
    if (Platform.isAndroid) {
      _moEAndroid.showInApp();
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodShowInApp);
    }
  }

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout() {
    if (Platform.isAndroid) {
      _moEAndroid.logout();
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodLogout);
    }
  }

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp() {
    if (Platform.isAndroid) {
      _moEAndroid.getSelfHandledInApp();
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSelfHandledInApp);
    }
  }

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "impression";
    if (Platform.isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSelfHandledCallback, payload);
    }
  }

  /// Mark self-handled campaign as primary clicked.
  /// API to be called only when in-app is self handled
  void selfHandledPrimaryClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "primary_clicked";
    if (Platform.isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSelfHandledCallback, payload);
    }
  }

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "click";
    if (Platform.isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSelfHandledCallback, payload);
    }
  }

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(InAppCampaign inAppCampaign) {
    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = "dismissed";
    if (Platform.isAndroid) {
      _moEAndroid.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSelfHandledCallback, payload);
    }
  }

  ///Set the current context for the given user.
  void setCurrentContext(List<String> contexts) {
    if (Platform.isAndroid) {
      _moEAndroid.setCurrentContext(contexts);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodSetAppContext,
        getMap(keyContexts, contexts));
    }
  }

  void resetCurrentContext() {
    if (Platform.isAndroid) {
      _moEAndroid.resetCurrentContext();
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodResetAppContext);
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  @Deprecated("message")
  void passPushToken(String pushToken) {
    if (Platform.isAndroid) {
      _moEAndroid.passPushToken(pushToken);
    }
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  @Deprecated("message")
  void passPushPayload(Map<String, String> payload) {
    if (Platform.isAndroid) {
      _moEAndroid.passPushPayload(payload);
    }
  }

  ///Optionally opt-out of data tracking. When data tracking is opted no event
  ///or user attribute is tracked on MoEngage Platform.
  void optOutDataTracking(bool shouldOptOutDataTracking) {
    if (Platform.isAndroid) {
      _moEAndroid.optOutDataTracking(shouldOptOutDataTracking);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayload(
          gdprOptOutTypeData, shouldOptOutDataTracking));
    }
  }

  ///Optionally opt-out of push campaigns.
  ///No push campaigns will be shown once this is opted out.
  void optOutPushTracking(bool shouldOptOutDataTracking) {
    if (Platform.isAndroid) {
      _moEAndroid.optOutPushTracking(shouldOptOutDataTracking);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayload(
          gdprOptOutTypePush, shouldOptOutDataTracking));
    }
  }

  ///Optionally opt-out of in-app campaigns.
  ///No in-app campaigns will be shown once this is  opted out.
  void optOutInAppTracking(bool shouldOptOutDataTracking) {
    if (Platform.isAndroid) {
      _moEAndroid.optOutInAppTracking(shouldOptOutDataTracking);
    } else if (Platform.isIOS) {
      _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayload(
          gdprOptOutTypeInApp, shouldOptOutDataTracking));
    }
  }
}
