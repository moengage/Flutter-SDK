import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moengage_flutter/src/moe_android_core.dart';
import 'package:moengage_flutter/src/moe_ios_core.dart';
import 'package:moengage_flutter/src/properties.dart';

import 'moengage_flutter_platform_interface.dart';
import 'src/constants.dart';
import 'src/core_instance_provider.dart';
import 'src/custom_type.dart';
import 'src/in_app_payload_mapper.dart';
import 'src/model/app_status.dart';
import 'src/model/gender.dart';
import 'src/model/geo_location.dart';
import 'src/model/inapp/click_data.dart';
import 'src/model/inapp/inapp_data.dart';
import 'src/model/inapp/self_handled_data.dart';
import 'src/model/permission_result.dart';
import 'src/model/permission_type.dart';
import 'src/model/push/moe_push_service.dart';
import 'src/model/push/push_campaign_data.dart';
import 'src/model/push/push_token_data.dart';
import 'src/moe_cache.dart';
import 'src/push_payload_mapper.dart';
import 'src/utils.dart';

/// An implementation of [MoengagePlatform] that uses method channels.
class MethodChannelMoengageFlutter extends MoengageFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(channelName);
  late MoEAndroidCore androidChannel;
  late MoEiOSCore iOSChannel;

  final String _tag = "${TAG}MethodChannelMoengage";

  MethodChannelMoengageFlutter() {
    androidChannel = MoEAndroidCore(methodChannel);
    iOSChannel = MoEiOSCore(methodChannel);

    methodChannel.setMethodCallHandler(_handler);
  }

  Future<dynamic> _handler(MethodCall call) async {
    debugPrint("$_tag _handler() : Received callback. Payload ${call.method}");
    try {
      if (call.method == callbackPushTokenGenerated) {
        PushTokenData? data =
            PushPayloadMapper().pushTokenFromJson(call.arguments);
        if (data != null) {
          PushTokenCallbackHandler? handler = Cache().pushTokenCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnPushClick) {
        PushCampaignData? data =
            PushPayloadMapper().pushCampaignFromJson(call.arguments);
        if (data != null) {
          PushClickCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .pushClickCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppClicked ||
          call.method == callbackOnInAppCustomAction) {
        ClickData? data = InAppPayloadMapper().actionFromJson(call.arguments);
        if (data != null) {
          InAppClickCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppClickCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppShown) {
        InAppData? data =
            InAppPayloadMapper().inAppDataFromJson(call.arguments);
        if (data != null) {
          InAppShownCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppShownCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppDismissed) {
        InAppData? data =
            InAppPayloadMapper().inAppDataFromJson(call.arguments);
        if (data != null) {
          InAppDismissedCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppDismissedCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppSelfHandled) {
        SelfHandledCampaignData? data =
            InAppPayloadMapper().selfHandledCampaignFromJson(call.arguments);
        debugPrint("$_tag _handler() : data: $data");
        if (data != null) {
          SelfHandledInAppCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .selfHandledInAppCallbackHandler;
          debugPrint("$_tag _handler() : handler: $handler");
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackPermissionResult) {
        PermissionResultCallbackHandler? handler =
            Cache().permissionResultCallbackHandler;
        if (handler != null) {
          PermissionResultData data = permissionResultFromMap(call.arguments);
          handler.call(data);
        }
      }
    } catch (e) {
      debugPrint("$_tag Error: ${call.toString()} has an Exception: $e");
    }
  }

  @override
  void initialise(String appId) =>
      methodChannel.invokeMethod(methodInitialise, getAccountMeta(appId));

  @override
  void setPushClickCallbackHandler({
    required String appId,
    PushClickCallbackHandler? handler,
  }) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .pushClickCallbackHandler = handler;
  }

  @override
  void setPushTokenCallbackHandler(PushTokenCallbackHandler? handler) {
    Cache().pushTokenCallbackHandler = handler;
  }

  @override
  void setInAppClickHandler({
    required String appId,
    InAppClickCallbackHandler? handler,
  }) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inAppClickCallbackHandler = handler;
  }

  @override
  void setInAppShownCallbackHandler({
    required String appId,
    InAppShownCallbackHandler? handler,
  }) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inAppShownCallbackHandler = handler;
  }

  @override
  void setInAppDismissedCallbackHandler({
    required String appId,
    InAppDismissedCallbackHandler? handler,
  }) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inAppDismissedCallbackHandler = handler;
  }

  @override
  void setSelfHandledInAppHandler({
    required String appId,
    SelfHandledInAppCallbackHandler? handler,
  }) {
    CoreInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .selfHandledInAppCallbackHandler = handler;
  }

  /// Tracks an event with the given attributes.
  @override
  void trackEvent({
    required String appId,
    required String eventName,
    MoEProperties? eventAttributes,
  }) {
    if (eventAttributes == null) {
      eventAttributes = MoEProperties();
    }
    if (Platform.isAndroid) {
      androidChannel.trackEvent(eventName, eventAttributes, appId);
    } else if (Platform.isIOS) {
      iOSChannel.trackEvent(eventName, eventAttributes, appId);
    }
  }

  /// Set a unique identifier for a user.<br/>
  @override
  void setUniqueId({
    required String appId,
    required String uniqueId,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setUniqueId(uniqueId, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setUniqueId(uniqueId, appId);
    }
  }

  /// Update user's unique id which was previously set by setUniqueId().
  @override
  void setAlias({
    required String appId,
    required String newUniqueId,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setAlias(newUniqueId, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setAlias(newUniqueId, appId);
    }
  }

  /// Tracks user-name as a user attribute.
  @override
  void setUserName({
    required String appId,
    required String userName,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setUserName(userName, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setUserName(userName, appId);
    }
  }

  /// Tracks first name as a user attribute.
  @override
  void setFirstName({
    required String appId,
    required String firstName,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setFirstName(firstName, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setFirstName(firstName, appId);
    }
  }

  /// Tracks last name as a user attribute.
  @override
  void setLastName({
    required String appId,
    required String lastName,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setLastName(lastName, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setLastName(lastName, appId);
    }
  }

  /// Tracks user's email-id as a user attribute.
  @override
  void setEmail({
    required String appId,
    required String emailId,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setEmail(emailId, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setEmail(emailId, appId);
    }
  }

  /// Tracks phone number as a user attribute.
  @override
  void setPhoneNumber({
    required String appId,
    required String phoneNumber,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setPhoneNumber(phoneNumber, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setPhoneNumber(phoneNumber, appId);
    }
  }

  /// Tracks gender as a user attribute.
  @override
  void setGender({
    required String appId,
    required MoEGender gender,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setGender(gender, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setGender(gender, appId);
    }
  }

  /// Set's user's location
  @override
  void setLocation({
    required String appId,
    required MoEGeoLocation location,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setLocation(location, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setLocation(location, appId);
    }
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  @override
  void setBirthDate({
    required String appId,
    required String birthDate,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setBirthDate(birthDate, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setBirthDate(birthDate, appId);
    }
  }

  /// Tracks a user attribute.
  @override
  void setUserAttribute({
    required String appId,
    required String userAttributeName,
    dynamic userAttributeValue,
  }) {
    if (userAttributeName.isEmpty) {
      print("User Attribute Name cannot be empty");
      return;
    }
    if (userAttributeValue is String ||
        userAttributeValue is int ||
        userAttributeValue is double ||
        userAttributeValue is bool) {
      if (Platform.isAndroid) {
        androidChannel.setUserAttribute(
            userAttributeName, userAttributeValue, appId);
      } else if (Platform.isIOS) {
        iOSChannel.setUserAttribute(
            userAttributeName, userAttributeValue, appId);
      }
    } else {
      print(
          "Only String, Numbers and Bool values supported as User Attributes");
    }
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  @override
  void setUserAttributeIsoDate({
    required String appId,
    required String userAttributeName,
    required String isoDateString,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setUserAttributeIsoDate(
          userAttributeName, isoDateString, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setUserAttributeIsoDate(
          userAttributeName, isoDateString, appId);
    }
  }

  /// Tracks the given location as user attribute.
  @override
  void setUserAttributeLocation({
    required String appId,
    required String userAttributeName,
    required MoEGeoLocation location,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setUserAttributeLocation(
          userAttributeName, location, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setUserAttributeLocation(userAttributeName, location, appId);
    }
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  @override
  void setAppStatus({
    required String appId,
    required MoEAppStatus appStatus,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setAppStatus(appStatus, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setAppStatus(appStatus, appId);
    }
  }

  /// Try to show an InApp Message.
  @override
  void showInApp(String appId) {
    if (Platform.isAndroid) {
      androidChannel.showInApp(appId);
    } else if (Platform.isIOS) {
      iOSChannel.showInApp(appId);
    }
  }

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  @override
  void logout(String appId) {
    if (Platform.isAndroid) {
      androidChannel.logout(appId);
    } else if (Platform.isIOS) {
      iOSChannel.logout(appId);
    }
  }

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  @override
  void getSelfHandledInApp(String appId) {
    if (Platform.isAndroid) {
      androidChannel.getSelfHandledInApp(appId);
    } else if (Platform.isIOS) {
      iOSChannel.getSelfHandledInApp(appId);
    }
  }

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  @override
  void selfHandledShown(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionShown);
    if (Platform.isAndroid) {
      androidChannel.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      iOSChannel.selfHandledCallback(payload);
    }
  }

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  @override
  void selfHandledClicked(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionClick);
    if (Platform.isAndroid) {
      androidChannel.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      iOSChannel.selfHandledCallback(payload);
    }
  }

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  @override
  void selfHandledDismissed(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionDismissed);
    if (Platform.isAndroid) {
      androidChannel.selfHandledCallback(payload);
    } else if (Platform.isIOS) {
      iOSChannel.selfHandledCallback(payload);
    }
  }

  ///Set the current context for the given user.
  @override
  void setCurrentContext({
    required String appId,
    required List<String> contexts,
  }) {
    if (Platform.isAndroid) {
      androidChannel.setCurrentContext(contexts, appId);
    } else if (Platform.isIOS) {
      iOSChannel.setCurrentContext(contexts, appId);
    }
  }

  @override
  void resetCurrentContext(String appId) {
    if (Platform.isAndroid) {
      androidChannel.resetCurrentContext(appId);
    } else if (Platform.isIOS) {
      iOSChannel.resetCurrentContext(appId);
    }
  }

  ///Optionally opt-in data tracking.
  @override
  void enableDataTracking(String appId) {
    if (Platform.isAndroid) {
      androidChannel.optOutDataTracking(false, appId);
    } else if (Platform.isIOS) {
      iOSChannel.optOutDataTracking(false, appId);
    }
  }

  ///Optionally opt-out of data tracking. When data tracking is opted-out no
  ///event or user attribute is tracked on MoEngage Platform.
  @override
  void disableDataTracking(String appId) {
    if (Platform.isAndroid) {
      androidChannel.optOutDataTracking(true, appId);
    } else if (Platform.isIOS) {
      iOSChannel.optOutDataTracking(true, appId);
    }
  }

  /// Push Notification Registration
  /// Note: This API is only for iOS Platform.
  @override
  void registerForPushNotification() {
    if (Platform.isIOS) {
      iOSChannel.registerForPushNotification();
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  @override
  void passFCMPushToken({
    required String appId,
    required String pushToken,
  }) {
    if (Platform.isAndroid) {
      androidChannel.passPushToken(pushToken, MoEPushService.fcm, appId);
    }
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  @override
  void passFCMPushPayload({
    required String appId,
    required Map<String, dynamic> payload,
  }) {
    if (Platform.isAndroid) {
      androidChannel.passPushPayload(payload, MoEPushService.fcm, appId);
    }
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  @override
  void passPushKitPushToken({
    required String appId,
    required String pushToken,
  }) {
    if (Platform.isAndroid) {
      androidChannel.passPushToken(pushToken, MoEPushService.push_kit, appId);
    }
  }

  /// API to enable SDK usage.
  /// Note: By default the SDK is enabled, should only be called to enabled the
  /// SDK if you have called [disableSdk()] at some point.
  @override
  void enableSdk(String appId) {
    if (Platform.isAndroid) {
      androidChannel.updateSdkState(true, appId);
    } else if (Platform.isIOS) {
      iOSChannel.updateSdkState(true, appId);
    }
  }

  /// API to disable all features of the SDK.
  @override
  void disableSdk(String appId) {
    if (Platform.isAndroid) {
      androidChannel.updateSdkState(false, appId);
    } else if (Platform.isIOS) {
      iOSChannel.updateSdkState(false, appId);
    }
  }

  @override
  void onOrientationChanged() {
    if (Platform.isAndroid) {
      androidChannel.onOrientationChanged();
    }
  }

  ///API to enable Android-id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  @override
  void enableAndroidIdTracking(String appId) {
    if (Platform.isAndroid) {
      androidChannel.updateDeviceIdentifierTrackingStatus(
          appId, keyAndroidId, true);
    }
  }

  ///API to enable Android-id tracking for the given instance.
  ///By default Android-id tracking is disabled, call this method only if you
  ///have enabled Android-id tracking at some point.
  /// Note: This API is only for Android Platform.
  @override
  void disableAndroidIdTracking(String appId) {
    if (Platform.isAndroid) {
      androidChannel.updateDeviceIdentifierTrackingStatus(
          appId, keyAndroidId, false);
    }
  }

  ///API to enable Advertising Id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  @override
  void enableAdIdTracking(String appId) {
    if (Platform.isAndroid) {
      androidChannel.updateDeviceIdentifierTrackingStatus(appId, keyAdId, true);
    }
  }

  ///API to disable Advertising Id tracking for the account configured as default.
  ///By default Advertising Id tracking is disabled, call this method only if
  ///you have enabled Advertising Id tracking at some point
  /// Note: This API is only for Android Platform.
  @override
  void disableAdIdTracking(String appId) {
    if (Platform.isAndroid) {
      androidChannel.updateDeviceIdentifierTrackingStatus(
          appId, keyAdId, false);
    }
  }

  ///API to create notification channels on Android.
  /// Note: This API is only for Android Platform.
  @override
  void setupNotificationChannelsAndroid() {
    if (Platform.isAndroid) {
      androidChannel.setupNotificationChannel();
    }
  }

  /// Notify the SDK on notification permission granted to the application.
  /// Note: This API is only for Android Platform.
  @override
  void pushPermissionResponseAndroid(bool isGranted) {
    if (Platform.isAndroid) {
      androidChannel.permissionResponse(isGranted, PermissionType.PUSH);
    }
  }

  /// Navigates the user to the Notification settings on Android 8 or above,
  /// on older versions the user is navigated the application settings or
  /// application info screen.
  /// Note: This API is only for Android Platform.
  @override
  void navigateToSettingsAndroid() {
    if (Platform.isAndroid) {
      androidChannel.navigateToSettings();
    }
  }

  /// Requests the push permission on Android 13 and above.
  /// Note: This API is only for Android Platform.
  @override
  void requestPushPermissionAndroid() {
    if (Platform.isAndroid) {
      androidChannel.requestPushPermissionAndroid();
    }
  }

  /// Setup a callback handler for getting the response permission
  @override
  void setPermissionCallbackHandler(PermissionResultCallbackHandler? handler) =>
      Cache().permissionResultCallbackHandler = handler;
}
