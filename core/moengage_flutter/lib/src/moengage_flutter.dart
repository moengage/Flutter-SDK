import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

class MoEngageFlutter {
  MoEngageFlutter(this.appId, {MoEInitConfig? moEInitConfig})
      : _moEInitConfig = moEInitConfig ?? MoEInitConfig.defaultConfig();
  String appId;
  final MoEInitConfig _moEInitConfig;

  MoEngageFlutterPlatform get _platform => MoEngageFlutterPlatform.instance;

  void initialise() {
    _platform.initialise(_moEInitConfig, appId);
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
    eventAttributes ??= MoEProperties();
    _platform.trackEvent(eventName, eventAttributes, appId);
  }

  /// Set a unique identifier for a user.<br/>
  void setUniqueId(String uniqueId) {
    _platform.setUniqueId(uniqueId, appId);
  }

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId) {
    _platform.setAlias(newUniqueId, appId);
  }

  /// Tracks user-name as a user attribute.
  void setUserName(String userName) {
    _platform.setUserName(userName, appId);
  }

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName) {
    _platform.setFirstName(firstName, appId);
  }

  /// Tracks last name as a user attribute.
  void setLastName(String lastName) {
    _platform.setLastName(lastName, appId);
  }

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId) {
    _platform.setEmail(emailId, appId);
  }

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber) {
    _platform.setPhoneNumber(phoneNumber, appId);
  }

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender) {
    _platform.setGender(gender, appId);
  }

  /// Set's user's location
  void setLocation(MoEGeoLocation location) {
    _platform.setLocation(location, appId);
  }

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate) {
    _platform.setBirthDate(birthDate, appId);
  }

  /// Tracks a user attribute.
  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    if (userAttributeName.isEmpty) {
      Logger.w('User Attribute Name cannot be empty');
      return;
    }
    if (userAttributeValue is String ||
        userAttributeValue is int ||
        userAttributeValue is double ||
        userAttributeValue is bool) {
      _platform.setUserAttribute(userAttributeName, userAttributeValue, appId);
    } else {
      Logger.w(
          'Only String, Numbers and Bool values supported as User Attributes');
    }
  }

  /// Tracks th given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    _platform.setUserAttributeIsoDate(userAttributeName, isoDateString, appId);
  }

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location) {
    _platform.setUserAttributeLocation(userAttributeName, location, appId);
  }

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus) {
    _platform.setAppStatus(appStatus, appId);
  }

  /// Try to show an InApp Message.
  void showInApp() {
    _platform.showInApp(appId);
  }

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout() {
    _platform.logout(appId);
  }

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp() {
    _platform.getSelfHandledInApp(appId);
  }

  /// Mark self-handled campaign as shown.
  /// API to be called only when in-app is self handled
  void selfHandledShown(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionShown);
    _platform.selfHandledCallback(payload);
  }

  /// Mark self-handled campaign as clicked.
  /// API to be called only when in-app is self handled
  void selfHandledClicked(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionClick);
    _platform.selfHandledCallback(payload);
  }

  /// Mark self-handled campaign as dismissed.
  /// API to be called only when in-app is self handled
  void selfHandledDismissed(SelfHandledCampaignData data) {
    Map<String, dynamic> payload = InAppPayloadMapper()
        .selfHandleCampaignDataToMap(data, selfHandledActionDismissed);
    _platform.selfHandledCallback(payload);
  }

  ///Set the current context for the given user.
  void setCurrentContext(List<String> contexts) {
    _platform.setCurrentContext(contexts, appId);
  }

  void resetCurrentContext() {
    _platform.resetCurrentContext(appId);
  }

  ///Optionally opt-in data tracking.
  void enableDataTracking() {
    _platform.optOutDataTracking(false, appId);
  }

  ///Optionally opt-out of data tracking. When data tracking is opted-out no
  ///event or user attribute is tracked on MoEngage Platform.
  void disableDataTracking() {
    _platform.optOutDataTracking(true, appId);
  }

  /// Push Notification Registration
  /// Note: This API is only for iOS Platform.
  void registerForPushNotification() {
    _platform.registerForPushNotification();
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushToken(String pushToken) {
    _platform.passPushToken(pushToken, MoEPushService.fcm, appId);
  }

  /// Pass FCM Push Payload to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passFCMPushPayload(Map<String, dynamic> payload) {
    _platform.passPushPayload(payload, MoEPushService.fcm, appId);
  }

  /// Pass FCM Push Token to the MoEngage SDK.
  /// Note: This API is only for Android Platform.
  void passPushKitPushToken(String pushToken) {
    _platform.passPushToken(pushToken, MoEPushService.push_kit, appId);
  }

  /// API to enable SDK usage.
  /// Note: By default the SDK is enabled, should only be called to enabled the
  /// SDK if you have called [disableSdk()] at some point.
  void enableSdk() {
    _platform.updateSdkState(true, appId);
  }

  /// API to disable all features of the SDK.
  void disableSdk() {
    _platform.updateSdkState(false, appId);
  }

  void onOrientationChanged() {
    _platform.onOrientationChanged();
  }

  ///API to enable Android-id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAndroidIdTracking() {
    _platform.updateDeviceIdentifierTrackingStatus(appId, keyAndroidId, true);
  }

  ///API to enable Android-id tracking for the given instance.
  ///By default Android-id tracking is disabled, call this method only if you
  ///have enabled Android-id tracking at some point.
  /// Note: This API is only for Android Platform.
  void disableAndroidIdTracking() {
    _platform.updateDeviceIdentifierTrackingStatus(appId, keyAndroidId, false);
  }

  ///API to enable Advertising Id tracking for the given instance.
  /// Note: This API is only for Android Platform.
  void enableAdIdTracking() {
    _platform.updateDeviceIdentifierTrackingStatus(appId, keyAdId, true);
  }

  ///API to disable Advertising Id tracking for the account configured as default.
  ///By default Advertising Id tracking is disabled, call this method only if
  ///you have enabled Advertising Id tracking at some point
  /// Note: This API is only for Android Platform.
  void disableAdIdTracking() {
    _platform.updateDeviceIdentifierTrackingStatus(appId, keyAdId, false);
  }

  ///API to create notification channels on Android.
  /// Note: This API is only for Android Platform.
  void setupNotificationChannelsAndroid() {
    _platform.setupNotificationChannel();
  }

  /// Notify the SDK on notification permission granted to the application.
  /// Note: This API is only for Android Platform.
  void pushPermissionResponseAndroid(bool isGranted) {
    _platform.permissionResponse(isGranted, PermissionType.PUSH);
  }

  /// Navigates the user to the Notification settings on Android 8 or above,
  /// on older versions the user is navigated the application settings or
  /// application info screen.
  /// Note: This API is only for Android Platform.
  void navigateToSettingsAndroid() {
    _platform.navigateToSettings();
  }

  /// Requests the push permission on Android 13 and above.
  /// Note: This API is only for Android Platform.
  void requestPushPermissionAndroid() {
    _platform.requestPushPermissionAndroid();
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
    _platform.updatePushPermissionRequestCountAndroid(requestCount, appId);
  }

  /// Enable Device-id tracking. It is enabled by default, and should be called only if tracking is disabled at some point.
  /// Note: This API is only for Android Platform
  void enableDeviceIdTracking() {
    _platform.updateDeviceIdentifierTrackingStatus(appId, keyDeviceId, true);
  }

  /// Disables Device-id tracking
  /// Note: This API is only for Android Platform
  void disableDeviceIdTracking() {
    _platform.updateDeviceIdentifierTrackingStatus(appId, keyDeviceId, false);
  }
}
