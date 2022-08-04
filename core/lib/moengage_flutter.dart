import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/core_instance_provider.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/moe_cache.dart';
import 'package:moengage_flutter/moe_core_controller.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/model/geo_location.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/moe_ios_core.dart';
import 'package:moengage_flutter/moe_android_core.dart';
import 'package:moengage_flutter/model/push/moe_push_service.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';

typedef void PushClickCallbackHandler(PushCampaignData data);
typedef void PushTokenCallbackHandler(PushTokenData data);

typedef void SelfHandledInAppCallbackHandler(SelfHandledCampaignData data);
typedef void InAppClickCallbackHandler(ClickData data);
typedef void InAppShownCallbackHandler(InAppData data);
typedef void InAppDismissedCallbackHandler(InAppData data);

class MoEngageFlutter {
  String appId;
  MethodChannel _channel = MethodChannel(channelName);
  late MoEAndroidCore _moEAndroid;
  late MoEiOSCore _moEiOS;
  late CoreController controller;

  MoEngageFlutter(this.appId) {
    controller = CoreController();
  }

  void initialise() {
    // _channel.setMethodCallHandler(_handler);
    _channel.invokeMethod(methodInitialise);
  }

  void setPushClickCallbackHandler(PushClickCallbackHandler? handler) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .pushClickCallbackHandler = handler;
  }

  void setPushTokenCallbackHandler(PushTokenCallbackHandler? handler) {
    Cache().pushTokenCallbackHandler = handler;
  }

  void setInAppClickHandler(InAppClickCallbackHandler? handler) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inAppClickCallbackHandler = handler;
  }

  void setInAppShownCallbackHandler(InAppShownCallbackHandler? handler) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inAppShownCallbackHandler = handler;
  }

  void setInAppDismissedCallbackHandler(
      InAppDismissedCallbackHandler? handler) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inAppDismissedCallbackHandler = handler;
  }

  void setSelfHandledInAppHandler(SelfHandledInAppCallbackHandler? handler) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .selfHandledInAppCallbackHandler = handler;
  }

  /// Tracks an event with the given attributes.
  void trackEvent(String eventName, [MoEProperties? eventAttributes]) {
    if (eventAttributes == null) {
      eventAttributes = MoEProperties();
    }
    if (Platform.isAndroid) {
      controller.moEAndroid.trackEvent(eventName, eventAttributes, appId);
    } else if (Platform.isIOS) {
      _moEiOS.trackEvent(eventName, eventAttributes, appId);
    }
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    if (Platform.isAndroid) {
      _moEAndroid.setUniqueId(uniqueId, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setUniqueId(uniqueId, appId);
    }
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    if (Platform.isAndroid) {
      _moEAndroid.setAlias(newUniqueId, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setAlias(newUniqueId, appId);
    }
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    if (Platform.isAndroid) {
      _moEAndroid.setUserName(userName, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setUserName(userName, appId);
    }
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    if (Platform.isAndroid) {
      _moEAndroid.setFirstName(firstName, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setFirstName(firstName, appId);
    }
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    if (Platform.isAndroid) {
      _moEAndroid.setLastName(lastName, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setLastName(lastName, appId);
    }
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    if (Platform.isAndroid) {
      _moEAndroid.setEmail(emailId, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setEmail(emailId, appId);
    }
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    if (Platform.isAndroid) {
      _moEAndroid.setPhoneNumber(phoneNumber, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setPhoneNumber(phoneNumber, appId);
    }
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    if (Platform.isAndroid) {
      _moEAndroid.setGender(gender, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setGender(gender, appId);
    }
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    if (Platform.isAndroid) {
      _moEAndroid.setLocation(location, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setLocation(location, appId);
    }
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    if (Platform.isAndroid) {
      _moEAndroid.setBirthDate(birthDate, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setBirthDate(birthDate, appId);
    }
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    if (userAttributeName.isEmpty) {
      print("User Attribute Name cannot be empty");
      return;
    }
    if (userAttributeValue is String ||
        userAttributeValue is int ||
        userAttributeValue is double ||
        userAttributeValue is bool) {
      if (Platform.isAndroid) {
        _moEAndroid.setUserAttribute(
            userAttributeName, userAttributeValue, appId);
      } else if (Platform.isIOS) {
        _moEiOS.setUserAttribute(userAttributeName, userAttributeValue, appId);
      }
    } else {
      print(
          "Only String, Numbers and Bool values supported as User Attributes");
    }
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    if (Platform.isAndroid) {
      _moEAndroid.setUserAttributeIsoDate(
          userAttributeName, isoDateString, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setUserAttributeIsoDate(userAttributeName, isoDateString, appId);
    }
  }

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location) {
    if (Platform.isAndroid) {
      _moEAndroid.setUserAttributeLocation(userAttributeName, location, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setUserAttributeLocation(userAttributeName, location, appId);
    }
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    if (Platform.isAndroid) {
      _moEAndroid.setAppStatus(appStatus, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setAppStatus(appStatus, appId);
    }
  }

  /// Try to show an InApp Message.
  void showInApp() {
    if (Platform.isAndroid) {
      _moEAndroid.showInApp(appId);
    } else if (Platform.isIOS) {
      _moEiOS.showInApp(appId);
    }
  }

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout() {
    if (Platform.isAndroid) {
      _moEAndroid.logout(appId);
    } else if (Platform.isIOS) {
      _moEiOS.logout(appId);
    }
  }

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp() {
    if (Platform.isAndroid) {
      _moEAndroid.getSelfHandledInApp(appId);
    } else if (Platform.isIOS) {
      _moEiOS.getSelfHandledInApp(appId);
    }
  }

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(SelfHandledCampaignData data) {
    // Map<String, dynamic> payload = inAppCampaign.toMap();
    // payload[keyAttributeType] = selfHandledActionShown;
    // if (Platform.isAndroid) {
    //   _moEAndroid.selfHandledCallback(payload, appId);
    // } else if (Platform.isIOS) {
    //   _moEiOS.selfHandledCallback(payload);
    // }
  }

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(SelfHandledCampaignData data) {
/*    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = selfHandledActionClick;
    if (Platform.isAndroid) {
      _moEAndroid.selfHandledCallback(payload, appId);
    } else if (Platform.isIOS) {
      _moEiOS.selfHandledCallback(payload);
    }*/
  }

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(SelfHandledCampaignData data) {
/*    Map<String, dynamic> payload = inAppCampaign.toMap();
    payload[keyAttributeType] = selfHandledActionDismissed;
    if (Platform.isAndroid) {
      _moEAndroid.selfHandledCallback(payload, appId);
    } else if (Platform.isIOS) {
      _moEiOS.selfHandledCallback(payload);
    }*/
  }

  ///Set the current context for the given user.
  void setCurrentContext(List<String> contexts) {
    if (Platform.isAndroid) {
      _moEAndroid.setCurrentContext(contexts, appId);
    } else if (Platform.isIOS) {
      _moEiOS.setCurrentContext(contexts, appId);
    }
  }

  void resetCurrentContext() {
    if (Platform.isAndroid) {
      _moEAndroid.resetCurrentContext(appId);
    } else if (Platform.isIOS) {
      _moEiOS.resetCurrentContext(appId);
    }
  }

  ///Optionally opt-out of data tracking. When data tracking is opted no event
  ///or user attribute is tracked on MoEngage Platform.
  void optOutDataTracking(bool shouldOptOutDataTracking) {
    if (Platform.isAndroid) {
      _moEAndroid.optOutDataTracking(shouldOptOutDataTracking, appId);
    } else if (Platform.isIOS) {
      _moEiOS.optOutDataTracking(shouldOptOutDataTracking, appId);
    }
  }

  /// Push Notification Registration
  /// Note: This API is only for iOS Platform.
  void registerForPushNotification() {
    if (Platform.isIOS) {
      _moEiOS.registerForPushNotification();
    }
  }

  /// Start Geofence Monitoring, Will work only if MOGeofence CocoaPod is integrated
  /// Note: This API is only for iOS Platform.
  void startGeofenceMonitoring() {
    if (Platform.isIOS) {
      _moEiOS.startGeofenceMonitoring();
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushToken(String pushToken) {
    if (Platform.isAndroid) {
      _moEAndroid.passPushToken(pushToken, MoEPushService.fcm, appId);
    }
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushPayload(Map<String, dynamic> payload) {
    if (Platform.isAndroid) {
      _moEAndroid.passPushPayload(payload, MoEPushService.fcm, appId);
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushKitPushToken(String pushToken) {
    if (Platform.isAndroid) {
      _moEAndroid.passPushToken(pushToken, MoEPushService.push_kit, appId);
    }
  }

  /// API to enable SDK usage.
  /// Note: By default the SDK is enabled, should only be called to enabled the
  /// SDK if you have called [disableSdk()] at some point.
  void enableSdk() {
    if (Platform.isAndroid) {
      _moEAndroid.updateSdkState(true, appId);
    } else if (Platform.isIOS) {
      _moEiOS.updateSdkState(true, appId);
    }
  }

  /// API to disable all features of the SDK.
  void disableSdk() {
    if (Platform.isAndroid) {
      _moEAndroid.updateSdkState(false, appId);
    } else if (Platform.isIOS) {
      _moEiOS.updateSdkState(false, appId);
    }
  }

  void onOrientationChanged() {
    if (Platform.isAndroid) {
      _moEAndroid.onOrientationChanged();
    }
  }
}
