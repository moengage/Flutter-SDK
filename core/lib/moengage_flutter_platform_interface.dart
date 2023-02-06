import 'package:moengage_flutter/moengage_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/custom_type.dart';
import 'src/internal/logger.dart';
import 'src/model/app_status.dart';
import 'src/model/gender.dart';
import 'src/model/geo_location.dart';
import 'src/model/inapp/self_handled_data.dart';
import 'src/properties.dart';

abstract class MoengageFlutterPlatform extends PlatformInterface {
  /// Constructs a MoengagePlatform.
  MoengageFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoengageFlutterPlatform _instance = MethodChannelMoengageFlutter();

  /// The default instance of [MoengagePlatform] to use.
  ///
  /// Defaults to [MethodChannelMoengage].
  static MoengageFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoengagePlatform] when
  /// they register themselves.
  static set instance(MoengageFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void initialise(String appId) =>
      throw UnimplementedError('initialise() has not been implemented.');

  void setPushClickCallbackHandler({
    required String appId,
    PushClickCallbackHandler? handler,
  }) =>
      throw UnimplementedError(
          'setPushClickCallbackHandler() has not been implemented.');

  void setPushTokenCallbackHandler(PushTokenCallbackHandler? handler) =>
      throw UnimplementedError(
          'setPushTokenCallbackHandler() has not been implemented.');

  void setInAppClickHandler({
    required String appId,
    InAppClickCallbackHandler? handler,
  }) =>
      throw UnimplementedError(
          'setInAppClickHandler() has not been implemented.');

  void setInAppShownCallbackHandler({
    required String appId,
    InAppShownCallbackHandler? handler,
  }) =>
      throw UnimplementedError(
          'setInAppShownCallbackHandler() has not been implemented.');

  void setInAppDismissedCallbackHandler({
    required String appId,
    InAppDismissedCallbackHandler? handler,
  }) =>
      throw UnimplementedError(
          'setInAppDismissedCallbackHandler() has not been implemented.');

  void setSelfHandledInAppHandler({
    required String appId,
    SelfHandledInAppCallbackHandler? handler,
  }) =>
      throw UnimplementedError(
          'setSelfHandledInAppHandler() has not been implemented.');

  /// Tracks an event with the given attributes.
  void trackEvent({
    required String appId,
    required String eventName,
    MoEProperties? eventAttributes,
  }) =>
      throw UnimplementedError('trackEvent() has not been implemented.');

  /// Set a unique identifier for a user.<br/>
  void setUniqueId({
    required String appId,
    required String uniqueId,
  }) =>
      throw UnimplementedError('setUniqueId() has not been implemented.');

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias({
    required String appId,
    required String newUniqueId,
  }) =>
      throw UnimplementedError('setAlias() has not been implemented.');

  /// Tracks user-name as a user attribute.
  void setUserName({
    required String appId,
    required String userName,
  }) =>
      throw UnimplementedError('setUserName() has not been implemented.');

  /// Tracks first name as a user attribute.
  void setFirstName({
    required String appId,
    required String firstName,
  }) =>
      throw UnimplementedError('setFirstName() has not been implemented.');

  /// Tracks last name as a user attribute.
  void setLastName({
    required String appId,
    required String lastName,
  }) =>
      throw UnimplementedError('setLastName() has not been implemented.');

  /// Tracks user's email-id as a user attribute.
  void setEmail({
    required String appId,
    required String emailId,
  }) =>
      throw UnimplementedError('setEmail() has not been implemented.');

  /// Tracks phone number as a user attribute.
  void setPhoneNumber({
    required String appId,
    required String phoneNumber,
  }) =>
      throw UnimplementedError('setPhoneNumber() has not been implemented.');

  /// Tracks gender as a user attribute.
  void setGender({
    required String appId,
    required MoEGender gender,
  }) =>
      throw UnimplementedError('setGender() has not been implemented.');

  /// Set's user's location
  void setLocation({
    required String appId,
    required MoEGeoLocation location,
  }) =>
      throw UnimplementedError('setLocation() has not been implemented.');

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate({
    required String appId,
    required String birthDate,
  }) =>
      throw UnimplementedError('setBirthDate() has not been implemented.');

  /// Tracks a user attribute.
  void setUserAttribute({
    required String appId,
    required String userAttributeName,
    dynamic userAttributeValue,
  }) =>
      throw UnimplementedError('setUserAttribute() has not been implemented.');

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate({
    required String appId,
    required String userAttributeName,
    required String isoDateString,
  }) =>
      throw UnimplementedError(
          'setUserAttributeIsoDate() has not been implemented.');

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation({
    required String appId,
    required String userAttributeName,
    required MoEGeoLocation location,
  }) =>
      throw UnimplementedError(
          'setUserAttributeLocation() has not been implemented.');

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus({
    required String appId,
    required MoEAppStatus appStatus,
  }) =>
      throw UnimplementedError('setAppStatus() has not been implemented.');

  /// Try to show an InApp Message.
  void showInApp(String appId) =>
      throw UnimplementedError('showInApp() has not been implemented.');

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout(String appId) =>
      throw UnimplementedError('logout() has not been implemented.');

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp(String appId) => throw UnimplementedError(
      'getSelfHandledInApp() has not been implemented.');

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(SelfHandledCampaignData data) =>
      throw UnimplementedError('selfHandledShown() has not been implemented.');

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(SelfHandledCampaignData data) =>
      throw UnimplementedError(
          'selfHandledClicked() has not been implemented.');

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(SelfHandledCampaignData data) =>
      throw UnimplementedError(
          'selfHandledDismissed() has not been implemented.');

  ///Set the current context for the given user.
  void setCurrentContext({
    required String appId,
    required List<String> contexts,
  }) =>
      throw UnimplementedError('setCurrentContext() has not been implemented.');

  void resetCurrentContext(String appId) => throw UnimplementedError(
      'resetCurrentContext() has not been implemented.');

  ///Optionally opt-in data tracking.
  void enableDataTracking(String appId) => throw UnimplementedError(
      'enableDataTracking() has not been implemented.');

  ///Optionally opt-out of data tracking. When data tracking is opted-out no
  ///event or user attribute is tracked on MoEngage Platform.
  void disableDataTracking(String appId) => throw UnimplementedError(
      'disableDataTracking() has not been implemented.');

  /// Push Notification Registration
  /// Note: This API is only for iOS Platform.
  void registerForPushNotification() => throw UnimplementedError(
      'registerForPushNotification() has not been implemented.');

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushToken({
    required String appId,
    required String pushToken,
  }) =>
      throw UnimplementedError('passFCMPushToken() has not been implemented.');

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushPayload({
    required String appId,
    required Map<String, dynamic> payload,
  }) =>
      throw UnimplementedError(
          'passFCMPushPayload() has not been implemented.');

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushKitPushToken({
    required String appId,
    required String pushToken,
  }) =>
      throw UnimplementedError(
          'passPushKitPushToken() has not been implemented.');

  /// API to enable SDK usage.
  /// Note: By default the SDK is enabled, should only be called to enabled the
  /// SDK if you have called [disableSdk()] at some point.
  void enableSdk(String appId) =>
      throw UnimplementedError('enableSdk() has not been implemented.');

  /// API to disable all features of the SDK.
  void disableSdk(String appId) =>
      throw UnimplementedError('disableSdk() has not been implemented.');

  void onOrientationChanged() => throw UnimplementedError(
      'onOrientationChanged() has not been implemented.');

  ///API to enable Android-id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAndroidIdTracking(String appId) => throw UnimplementedError(
      'enableAndroidIdTracking() has not been implemented.');

  ///API to enable Android-id tracking for the given instance.
  ///By default Android-id tracking is disabled, call this method only if you
  ///have enabled Android-id tracking at some point.
  /// Note: This API is only for Android Platform.
  void disableAndroidIdTracking(String appId) => throw UnimplementedError(
      'disableAndroidIdTracking() has not been implemented.');

  ///API to enable Advertising Id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAdIdTracking(String appId) => throw UnimplementedError(
      'enableAdIdTracking() has not been implemented.');

  ///API to disable Advertising Id tracking for the account configured as default.
  ///By default Advertising Id tracking is disabled, call this method only if
  ///you have enabled Advertising Id tracking at some point
  /// Note: This API is only for Android Platform.
  void disableAdIdTracking(String appId) => throw UnimplementedError(
      'disableAdIdTracking() has not been implemented.');

  ///API to create notification channels on Android.
  /// Note: This API is only for Android Platform.
  void setupNotificationChannelsAndroid() => throw UnimplementedError(
      'setupNotificationChannelsAndroid() has not been implemented.');

  /// Notify the SDK on notification permission granted to the application.
  /// Note: This API is only for Android Platform.
  void pushPermissionResponseAndroid(bool isGranted) =>
      throw UnimplementedError(
          'pushPermissionResponseAndroid() has not been implemented.');

  /// Navigates the user to the Notification settings on Android 8 or above,
  /// on older versions the user is navigated the application settings or
  /// application info screen.
  /// Note: This API is only for Android Platform.
  void navigateToSettingsAndroid() => throw UnimplementedError(
      'navigateToSettingsAndroid() has not been implemented.');

  /// Requests the push permission on Android 13 and above.
  /// Note: This API is only for Android Platform.
  void requestPushPermissionAndroid() => throw UnimplementedError(
      'requestPushPermissionAndroid() has not been implemented.');

  /// Setup a callback handler for getting the response permission
  void setPermissionCallbackHandler(PermissionResultCallbackHandler? handler) =>
      throw UnimplementedError(
          'setPermissionCallbackHandler() has not been implemented.');

  /// Configure MoEngage SDK Logs
  /// @param [logLevel] - [LogLevel] for SDK logs
  /// @param [isEnabledForReleaseBuild] If true, logs will be printed for the Release build. By default the logs are disabled for the Release build.
  void configureLogs({
    required LogLevel logLevel,
    bool isEnabledForReleaseBuild = false,
  }) =>
      throw UnimplementedError('configureLogs() has not been implemented.');

  /// Updates the number of the times Notification permission is requested
  /// @param [requestCount] This count will be incremented to existing value
  /// Note: This API is only applicable for Android Platform. This should not called in App/Widget lifecycle methods.
  void updatePushPermissionRequestCountAndroid({
    required String appId,
    required int requestCount,
  }) =>
      throw UnimplementedError(
          'updatePushPermissionRequestCountAndroid() has not been implemented.');
}
