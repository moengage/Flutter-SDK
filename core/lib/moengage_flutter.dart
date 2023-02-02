import 'dart:io';

import 'package:moengage_flutter/internal/logger.dart';
import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/core_instance_provider.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/permission_result.dart';
import 'package:moengage_flutter/model/permission_type.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/moe_cache.dart';
import 'package:moengage_flutter/moe_core_controller.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/model/geo_location.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/push/moe_push_service.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/utils.dart';

import 'in_app_payload_mapper.dart';

typedef void PushClickCallbackHandler(PushCampaignData data);
typedef void PushTokenCallbackHandler(PushTokenData data);

typedef void SelfHandledInAppCallbackHandler(SelfHandledCampaignData data);
typedef void InAppClickCallbackHandler(ClickData data);
typedef void InAppShownCallbackHandler(InAppData data);
typedef void InAppDismissedCallbackHandler(InAppData data);
typedef void PermissionResultCallbackHandler(PermissionResultData data);

class MoEngageFlutter {
  String appId;
  late CoreController controller;

  MoEngageFlutter(this.appId) {
    controller = CoreController();
  }

  void initialise() {
    controller.channel.invokeMethod(methodInitialise, getAccountMeta(appId));
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
      controller.moEiOS.trackEvent(eventName, eventAttributes, appId);
    }
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setUniqueId(uniqueId, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setUniqueId(uniqueId, appId);
    }
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setAlias(newUniqueId, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setAlias(newUniqueId, appId);
    }
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setUserName(userName, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setUserName(userName, appId);
    }
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setFirstName(firstName, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setFirstName(firstName, appId);
    }
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setLastName(lastName, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setLastName(lastName, appId);
    }
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setEmail(emailId, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setEmail(emailId, appId);
    }
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setPhoneNumber(phoneNumber, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setPhoneNumber(phoneNumber, appId);
    }
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setGender(gender, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setGender(gender, appId);
    }
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setLocation(location, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setLocation(location, appId);
    }
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setBirthDate(birthDate, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setBirthDate(birthDate, appId);
    }
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    if (userAttributeName.isEmpty) {
      Logger.w("User Attribute Name cannot be empty");
      return;
    }
    if (userAttributeValue is String ||
        userAttributeValue is int ||
        userAttributeValue is double ||
        userAttributeValue is bool) {
      if (Platform.isAndroid) {
        controller.moEAndroid
            .setUserAttribute(userAttributeName, userAttributeValue, appId);
      } else if (Platform.isIOS) {
        controller.moEiOS
            .setUserAttribute(userAttributeName, userAttributeValue, appId);
      }
    } else {
      Logger.w(
          "Only String, Numbers and Bool values supported as User Attributes");
    }
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .setUserAttributeIsoDate(userAttributeName, isoDateString, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS
          .setUserAttributeIsoDate(userAttributeName, isoDateString, appId);
    }
  }

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location) {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .setUserAttributeLocation(userAttributeName, location, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS
          .setUserAttributeLocation(userAttributeName, location, appId);
    }
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setAppStatus(appStatus, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setAppStatus(appStatus, appId);
    }
  }

  /// Try to show an InApp Message.
  void showInApp() {
    if (Platform.isAndroid) {
      controller.moEAndroid.showInApp(appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.showInApp(appId);
    }
  }

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout() {
    if (Platform.isAndroid) {
      controller.moEAndroid.logout(appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.logout(appId);
    }
  }

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp() {
    if (Platform.isAndroid) {
      controller.moEAndroid.getSelfHandledInApp(appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.getSelfHandledInApp(appId);
    }
  }

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionShown);
    if (Platform.isAndroid) {
      controller.moEAndroid.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      controller.moEiOS.selfHandledCallback(payload);
    }
  }

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionClick);
    if (Platform.isAndroid) {
      controller.moEAndroid.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      controller.moEiOS.selfHandledCallback(payload);
    }
  }

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionDismissed);
    if (Platform.isAndroid) {
      controller.moEAndroid.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      controller.moEiOS.selfHandledCallback(payload);
    }
  }

  ///Set the current context for the given user.
  void setCurrentContext(List<String> contexts) {
    if (Platform.isAndroid) {
      controller.moEAndroid.setCurrentContext(contexts, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.setCurrentContext(contexts, appId);
    }
  }

  void resetCurrentContext() {
    if (Platform.isAndroid) {
      controller.moEAndroid.resetCurrentContext(appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.resetCurrentContext(appId);
    }
  }

  ///Optionally opt-in data tracking.
  void enableDataTracking() {
    if (Platform.isAndroid) {
      controller.moEAndroid.optOutDataTracking(false, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.optOutDataTracking(false, appId);
    }
  }

  ///Optionally opt-out of data tracking. When data tracking is opted-out no
  ///event or user attribute is tracked on MoEngage Platform.
  void disableDataTracking() {
    if (Platform.isAndroid) {
      controller.moEAndroid.optOutDataTracking(true, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.optOutDataTracking(true, appId);
    }
  }

  /// Push Notification Registration
  /// Note: This API is only for iOS Platform.
  void registerForPushNotification() {
    if (Platform.isIOS) {
      controller.moEiOS.registerForPushNotification();
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushToken(String pushToken) {
    if (Platform.isAndroid) {
      controller.moEAndroid.passPushToken(pushToken, MoEPushService.fcm, appId);
    }
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushPayload(Map<String, dynamic> payload) {
    if (Platform.isAndroid) {
      controller.moEAndroid.passPushPayload(payload, MoEPushService.fcm, appId);
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushKitPushToken(String pushToken) {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .passPushToken(pushToken, MoEPushService.push_kit, appId);
    }
  }

  /// API to enable SDK usage.
  /// Note: By default the SDK is enabled, should only be called to enabled the
  /// SDK if you have called [disableSdk()] at some point.
  void enableSdk() {
    if (Platform.isAndroid) {
      controller.moEAndroid.updateSdkState(true, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.updateSdkState(true, appId);
    }
  }

  /// API to disable all features of the SDK.
  void disableSdk() {
    if (Platform.isAndroid) {
      controller.moEAndroid.updateSdkState(false, appId);
    } else if (Platform.isIOS) {
      controller.moEiOS.updateSdkState(false, appId);
    }
  }

  void onOrientationChanged() {
    if (Platform.isAndroid) {
      controller.moEAndroid.onOrientationChanged();
    }
  }

  ///API to enable Android-id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAndroidIdTracking() {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .updateDeviceIdentifierTrackingStatus(appId, keyAndroidId, true);
    }
  }

  ///API to enable Android-id tracking for the given instance.
  ///By default Android-id tracking is disabled, call this method only if you
  ///have enabled Android-id tracking at some point.
  /// Note: This API is only for Android Platform.
  void disableAndroidIdTracking() {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .updateDeviceIdentifierTrackingStatus(appId, keyAndroidId, false);
    }
  }

  ///API to enable Advertising Id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAdIdTracking() {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .updateDeviceIdentifierTrackingStatus(appId, keyAdId, true);
    }
  }

  ///API to disable Advertising Id tracking for the account configured as default.
  ///By default Advertising Id tracking is disabled, call this method only if
  ///you have enabled Advertising Id tracking at some point
  /// Note: This API is only for Android Platform.
  void disableAdIdTracking() {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .updateDeviceIdentifierTrackingStatus(appId, keyAdId, false);
    }
  }

  ///API to create notification channels on Android.
  /// Note: This API is only for Android Platform.
  void setupNotificationChannelsAndroid() {
    if (Platform.isAndroid) {
      controller.moEAndroid.setupNotificationChannel();
    }
  }

  /// Notify the SDK on notification permission granted to the application.
  /// Note: This API is only for Android Platform.
  void pushPermissionResponseAndroid(bool isGranted) {
    if (Platform.isAndroid) {
      controller.moEAndroid.permissionResponse(isGranted, PermissionType.PUSH);
    }
  }

  /// Navigates the user to the Notification settings on Android 8 or above,
  /// on older versions the user is navigated the application settings or
  /// application info screen.
  /// Note: This API is only for Android Platform.
  void navigateToSettingsAndroid() {
    if (Platform.isAndroid) {
      controller.moEAndroid.navigateToSettings();
    }
  }

  /// Requests the push permission on Android 13 and above.
  /// Note: This API is only for Android Platform.
  void requestPushPermissionAndroid() {
    if (Platform.isAndroid) {
      controller.moEAndroid.requestPushPermissionAndroid();
    }
  }

  /// Setup a callback handler for getting the response permission
  void setPermissionCallbackHandler(PermissionResultCallbackHandler? handler) {
    Cache().permissionResultCallbackHandler = handler;
  }

  /// Configure MoEngage SDK Logs
  /// @param [logLevel] - [LogLevel] for SDK logs
  /// @param [isEnabledForReleaseBuild] If true, logs will be printed for the Release build. By default the logs are disabled for the Release build.
  void configureLogs(LogLevel logLevel,
      {bool isEnabledForReleaseBuild = false}) {
    Logger.configureLogs(logLevel, isEnabledForReleaseBuild);
  }

  /// Updates the number of the times Notification permission is requested
  /// @param [requestCount] This count will be incremented to existing value
  /// Note: This API is only applicable for Android Platform. This should not called in App/Widget lifecycle methods.
  void updatePushPermissionRequestCountAndroid(int requestCount) {
    if (Platform.isAndroid) {
      controller.moEAndroid
          .updatePushPermissionRequestCountAndroid(requestCount, appId);
    }
  }
}
