import 'package:flutter/services.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

/// The iOS implementation of [MoEngageFlutterPlatform].
class MoEngageFlutterIOS extends MoEngageFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel(channelName);

  /// Registers this class as the default instance of [MoEngageFlutterPlatform]
  static void registerWith() {
    Logger.v('Registering MoEngageFlutterIOS with Platform Interface');
    MoEngageFlutterPlatform.instance = MoEngageFlutterIOS();
  }

  @override
  void initialise(MoEInitConfig moEInitConfig, String appId) {
    Logger.v('initialise(): ');
  }

  @override
  void trackEvent(
      String eventName, MoEProperties eventAttributes, String appId) {
    _channel.invokeMethod(
        methodTrackEvent, getEventPayload(eventName, eventAttributes, appId));
  }

  @override
  void setUniqueId(String uniqueId, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameUniqueId, userAttrTypeGeneral, uniqueId, appId));
  }

  @override
  void setAlias(String newUniqueId, String appId) {
    _channel.invokeMethod(methodSetAlias, getAliasPayload(newUniqueId, appId));
  }

  @override
  void setUserName(String userName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameUserName, userAttrTypeGeneral, userName, appId));
  }

  @override
  void setFirstName(String firstName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameFirstName, userAttrTypeGeneral, firstName, appId));
  }

  @override
  void setLastName(String lastName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameLastName, userAttrTypeGeneral, lastName, appId));
  }

  @override
  void setEmail(String emailId, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameEmailId, userAttrTypeGeneral, emailId, appId));
  }

  @override
  void setPhoneNumber(String phoneNumber, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNamePhoneNum, userAttrTypeGeneral, phoneNumber, appId));
  }

  @override
  void setGender(MoEGender gender, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(userAttrNameGender, userAttrTypeGeneral,
            genderToString(gender), appId));
  }

  @override
  void setLocation(MoEGeoLocation location, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(userAttrNameLocation, userAttrTypeLocation,
            location.toMap(), appId));
  }

  @override
  void setBirthDate(String birthDate, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameBirtdate, userAttrTypeTimestamp, birthDate, appId));
  }

  @override
  void setUserAttribute(
      String userAttributeName, dynamic userAttributeValue, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeGeneral, userAttributeValue, appId));
  }

  @override
  void setUserAttributeIsoDate(
      String userAttributeName, String isoDateString, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeTimestamp, isoDateString, appId));
  }

  @override
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeLocation, location.toMap(), appId));
  }

  @override
  void setAppStatus(MoEAppStatus appStatus, String appId) {
    _channel.invokeListMethod(
        methodSetAppStatus, getAppStatusPayload(appStatus, appId));
  }

  @override
  void showInApp(String appId) {
    _channel.invokeMethod(methodShowInApp, getAccountMeta(appId));
  }

  @override
  void getSelfHandledInApp(String appId) {
    _channel.invokeMethod(methodSelfHandledInApp, getAccountMeta(appId));
  }

  @override
  void selfHandledCallback(Map<String, dynamic> payload) {
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  @override
  void setCurrentContext(List<String> contexts, String appId) {
    _channel.invokeMethod(
        methodSetAppContext, getInAppContextPayload(contexts, appId));
  }

  @override
  void resetCurrentContext(String appId) {
    _channel.invokeMethod(methodResetAppContext, getAccountMeta(appId));
  }

  @override
  void registerForPushNotification() {
    _channel.invokeMethod(methodiOSRegisterPush);
  }

  @override
  void optOutDataTracking(bool optOutDataTracking, String appId) {
    _channel.invokeMethod(
        methodOptOutTracking,
        getOptOutTrackingPayload(
            gdprOptOutTypeData, optOutDataTracking, appId));
  }

  @override
  void logout(String appId) {
    _channel.invokeMethod(methodLogout, getAccountMeta(appId));
  }

  @override
  void updateSdkState(bool shouldEnableSdk, String appId) {
    _channel.invokeMethod(
        methodUpdateSdkState, getUpdateSdkStatePayload(shouldEnableSdk, appId));
  }

  @override
  void navigateToSettings() {
    Logger.v('navigateToSettings(): Not supported in iOS Platform');
  }

  @override
  void onOrientationChanged() {
    Logger.v('onOrientationChanged(): Not supported in iOS Platform');
  }

  @override
  void passPushPayload(
      Map<String, dynamic> payload, MoEPushService pushService, String appId) {
    Logger.v('passPushPayload(): Not supported in iOS Platform');
  }

  @override
  void passPushToken(
      String pushToken, MoEPushService pushService, String appId) {
    Logger.v('passPushToken(): Not supported in iOS Platform');
  }

  @override
  void permissionResponse(bool isGranted, PermissionType type) {
    Logger.v('permissionResponse(): Not supported in iOS Platform');
  }

  @override
  void requestPushPermission() {
    Logger.v('requestPushPermission(): Not supported in iOS Platform');
  }

  @override
  void setupNotificationChannel() {
    Logger.v('setupNotificationChannel(): Not supported in iOS Platform');
  }

  @override
  void updateDeviceIdentifierTrackingStatus(
      String appId, String identifierType, bool state) {
    Logger.v(
        'updateDeviceIdentifierTrackingStatus(): Not supported in iOS Platform');
  }

  @override
  void updatePushPermissionRequestCountAndroid(int requestCount, String appId) {
    Logger.v(
        'updatePushPermissionRequestCountAndroid(): Not supported in iOS Platform');
  }
}
