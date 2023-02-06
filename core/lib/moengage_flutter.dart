import 'moengage_flutter_platform_interface.dart';
import 'src/custom_type.dart';
import 'src/internal/logger.dart';
import 'src/model/app_status.dart';
import 'src/model/gender.dart';
import 'src/model/geo_location.dart';
import 'src/model/inapp/self_handled_data.dart';
import 'src/properties.dart';

export 'src/internal/logger.dart';

export 'src/callback_cache.dart';
export 'src/constants.dart';
export 'src/core_instance_provider.dart';
export 'src/data_payload_mapper.dart';
export 'src/in_app_payload_mapper.dart';
export 'src/moe_cache.dart';
export 'src/properties.dart';
export 'src/push_payload_mapper.dart';
export 'src/utils.dart';

export 'src/model/account_meta.dart';
export 'src/model/app_status.dart';
export 'src/model/gender.dart';
export 'src/model/geo_location.dart';
export 'src/model/permission_result.dart';
export 'src/model/permission_type.dart';
export 'src/model/platforms.dart';

export 'src/model/inapp/action.dart';
export 'src/model/inapp/campaign_context.dart';
export 'src/model/inapp/campaign_data.dart';
export 'src/model/inapp/click_data.dart';
export 'src/model/inapp/inapp_action_type.dart';
export 'src/model/inapp/inapp_custom_action.dart';
export 'src/model/inapp/inapp_data.dart';
export 'src/model/inapp/navigation_action.dart';
export 'src/model/inapp/navigation_type.dart';
export 'src/model/inapp/self_handled_campaign.dart';
export 'src/model/inapp/self_handled_data.dart';

export 'src/model/push/moe_push_service.dart';
export 'src/model/push/push_campaign.dart';
export 'src/model/push/push_campaign_data.dart';
export 'src/model/push/push_token_data.dart';

class MoEngageFlutter {
  String appId;

  MoEngageFlutter(this.appId);

  void initialise() => MoengageFlutterPlatform.instance.initialise(appId);

  void setPushClickCallbackHandler(PushClickCallbackHandler? handler) =>
      MoengageFlutterPlatform.instance
          .setPushClickCallbackHandler(appId: appId, handler: handler);

  void setPushTokenCallbackHandler(PushTokenCallbackHandler? handler) =>
      MoengageFlutterPlatform.instance.setPushTokenCallbackHandler(handler);

  void setInAppClickHandler(InAppClickCallbackHandler? handler) =>
      MoengageFlutterPlatform.instance
          .setInAppClickHandler(appId: appId, handler: handler);

  void setInAppShownCallbackHandler(InAppShownCallbackHandler? handler) =>
      MoengageFlutterPlatform.instance
          .setInAppShownCallbackHandler(appId: appId, handler: handler);

  void setInAppDismissedCallbackHandler(
          InAppDismissedCallbackHandler? handler) =>
      MoengageFlutterPlatform.instance
          .setInAppDismissedCallbackHandler(appId: appId, handler: handler);

  void setSelfHandledInAppHandler(SelfHandledInAppCallbackHandler? handler) =>
      MoengageFlutterPlatform.instance
          .setSelfHandledInAppHandler(appId: appId, handler: handler);

  /// Tracks an event with the given attributes.
  void trackEvent({
    required String eventName,
    MoEProperties? eventAttributes,
  }) =>
      MoengageFlutterPlatform.instance.trackEvent(
          appId: appId, eventName: eventName, eventAttributes: eventAttributes);

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) => MoengageFlutterPlatform.instance
      .setUniqueId(appId: appId, uniqueId: uniqueId);

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) => MoengageFlutterPlatform.instance
      .setAlias(appId: appId, newUniqueId: newUniqueId);

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) => MoengageFlutterPlatform.instance
      .setUserName(appId: appId, userName: userName);

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) => MoengageFlutterPlatform.instance
      .setFirstName(appId: appId, firstName: firstName);

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) => MoengageFlutterPlatform.instance
      .setLastName(appId: appId, lastName: lastName);

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) =>
      MoengageFlutterPlatform.instance.setEmail(appId: appId, emailId: emailId);

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) => MoengageFlutterPlatform.instance
      .setPhoneNumber(appId: appId, phoneNumber: phoneNumber);

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) =>
      MoengageFlutterPlatform.instance.setGender(appId: appId, gender: gender);

  /// Set's user's location
  void setLocation(MoEGeoLocation location) => MoengageFlutterPlatform.instance
      .setLocation(appId: appId, location: location);

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) => MoengageFlutterPlatform.instance
      .setBirthDate(appId: appId, birthDate: birthDate);

  /// Tracks a user attribute.
  void setUserAttribute({
    required String userAttributeName,
    dynamic userAttributeValue,
  }) =>
      MoengageFlutterPlatform.instance.setUserAttribute(
        appId: appId,
        userAttributeName: userAttributeName,
        userAttributeValue: userAttributeValue,
      );

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate({
    required String userAttributeName,
    required String isoDateString,
  }) =>
      MoengageFlutterPlatform.instance.setUserAttributeIsoDate(
        appId: appId,
        userAttributeName: userAttributeName,
        isoDateString: isoDateString,
      );

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation({
    required String userAttributeName,
    required MoEGeoLocation location,
  }) =>
      MoengageFlutterPlatform.instance.setUserAttributeLocation(
        appId: appId,
        userAttributeName: userAttributeName,
        location: location,
      );

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) =>
      MoengageFlutterPlatform.instance.setAppStatus(
        appId: appId,
        appStatus: appStatus,
      );

  /// Try to show an InApp Message.
  void showInApp() => MoengageFlutterPlatform.instance.showInApp(appId);

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout() => MoengageFlutterPlatform.instance.logout(appId);

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp() =>
      MoengageFlutterPlatform.instance.getSelfHandledInApp(appId);

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(SelfHandledCampaignData data) =>
      MoengageFlutterPlatform.instance.selfHandledShown(data);

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(SelfHandledCampaignData data) =>
      MoengageFlutterPlatform.instance.selfHandledClicked(data);

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(SelfHandledCampaignData data) =>
      MoengageFlutterPlatform.instance.selfHandledDismissed(data);

  ///Set the current context for the given user.
  void setCurrentContext(List<String> contexts) =>
      MoengageFlutterPlatform.instance
          .setCurrentContext(appId: appId, contexts: contexts);

  void resetCurrentContext() =>
      MoengageFlutterPlatform.instance.resetCurrentContext(appId);

  ///Optionally opt-in data tracking.
  void enableDataTracking() =>
      MoengageFlutterPlatform.instance.enableDataTracking(appId);

  ///Optionally opt-out of data tracking. When data tracking is opted-out no
  ///event or user attribute is tracked on MoEngage Platform.
  void disableDataTracking() =>
      MoengageFlutterPlatform.instance.disableDataTracking(appId);

  /// Push Notification Registration
  /// Note: This API is only for iOS Platform.
  void registerForPushNotification() =>
      MoengageFlutterPlatform.instance.registerForPushNotification();

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushToken(String pushToken) => MoengageFlutterPlatform.instance
      .passFCMPushToken(appId: appId, pushToken: pushToken);

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushPayload(Map<String, dynamic> payload) =>
      MoengageFlutterPlatform.instance
          .passFCMPushPayload(appId: appId, payload: payload);

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushKitPushToken(String pushToken) =>
      MoengageFlutterPlatform.instance
          .passPushKitPushToken(appId: appId, pushToken: pushToken);

  /// API to enable SDK usage.
  /// Note: By default the SDK is enabled, should only be called to enabled the
  /// SDK if you have called [disableSdk()] at some point.
  void enableSdk() => MoengageFlutterPlatform.instance.enableSdk(appId);

  /// API to disable all features of the SDK.
  void disableSdk() => MoengageFlutterPlatform.instance.disableSdk(appId);

  void onOrientationChanged() =>
      MoengageFlutterPlatform.instance.onOrientationChanged();

  ///API to enable Android-id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAndroidIdTracking() =>
      MoengageFlutterPlatform.instance.enableAndroidIdTracking(appId);

  ///API to enable Android-id tracking for the given instance.
  ///By default Android-id tracking is disabled, call this method only if you
  ///have enabled Android-id tracking at some point.
  /// Note: This API is only for Android Platform.
  void disableAndroidIdTracking() =>
      MoengageFlutterPlatform.instance.disableAndroidIdTracking(appId);

  ///API to enable Advertising Id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAdIdTracking() =>
      MoengageFlutterPlatform.instance.enableAdIdTracking(appId);

  ///API to disable Advertising Id tracking for the account configured as default.
  ///By default Advertising Id tracking is disabled, call this method only if
  ///you have enabled Advertising Id tracking at some point
  /// Note: This API is only for Android Platform.
  void disableAdIdTracking() =>
      MoengageFlutterPlatform.instance.disableAdIdTracking(appId);

  ///API to create notification channels on Android.
  /// Note: This API is only for Android Platform.
  void setupNotificationChannelsAndroid() =>
      MoengageFlutterPlatform.instance.setupNotificationChannelsAndroid();

  /// Notify the SDK on notification permission granted to the application.
  /// Note: This API is only for Android Platform.
  void pushPermissionResponseAndroid(bool isGranted) =>
      MoengageFlutterPlatform.instance.pushPermissionResponseAndroid(isGranted);

  /// Navigates the user to the Notification settings on Android 8 or above,
  /// on older versions the user is navigated the application settings or
  /// application info screen.
  /// Note: This API is only for Android Platform.
  void navigateToSettingsAndroid() =>
      MoengageFlutterPlatform.instance.navigateToSettingsAndroid();

  /// Requests the push permission on Android 13 and above.
  /// Note: This API is only for Android Platform.
  void requestPushPermissionAndroid() =>
      MoengageFlutterPlatform.instance.requestPushPermissionAndroid();

  /// Setup a callback handler for getting the response permission
  void setPermissionCallbackHandler(PermissionResultCallbackHandler? handler) =>
      MoengageFlutterPlatform.instance.setPermissionCallbackHandler(handler);

  void configureLogs({
    required LogLevel logLevel,
    bool isEnabledForReleaseBuild = false,
  }) =>
      MoengageFlutterPlatform.instance.configureLogs(
        logLevel: logLevel,
        isEnabledForReleaseBuild: isEnabledForReleaseBuild,
      );

  /// Updates the number of the times Notification permission is requested
  /// @param [requestCount] This count will be incremented to existing value
  /// Note: This API is only applicable for Android Platform. This should not called in App/Widget lifecycle methods.
  void updatePushPermissionRequestCountAndroid(int requestCount) =>
      MoengageFlutterPlatform.instance.updatePushPermissionRequestCountAndroid(
          appId: appId, requestCount: requestCount);
}
