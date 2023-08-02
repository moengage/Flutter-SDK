import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'package:moengage_flutter_platform_interface/src/utils/data_payload_mapper.dart';
import 'package:moengage_flutter_platform_interface/src/utils/utils.dart';

/// The Android implementation of [MoEngageFlutterPlatform].
class MoEngageFlutterAndroid extends MoEngageFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _methodChannel = const MethodChannel(channelName);

  /// Registers this class as the default instance of [MoEngageFlutterPlatform]
  static void registerWith() {
    MoEngageFlutterPlatform.instance = MoEngageFlutterAndroid();
  }

  @override
  void initialise(MoEInitConfig moEInitConfig, String appId) {
    _methodChannel.invokeMethod(methodInitialise,
        InitConfigPayloadMapper().getInitPayload(appId, moEInitConfig));
  }

  @override
  void trackEvent(
      String eventName, MoEProperties eventAttributes, String appId) {
    _methodChannel.invokeMethod(methodTrackEvent,
        json.encode(getEventPayload(eventName, eventAttributes, appId)));
  }

  @override
  void setUniqueId(String uniqueId, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameUniqueId, userAttrTypeGeneral, uniqueId, appId));
  }

  @override
  void setAlias(String newUniqueId, String appId) {
    _methodChannel.invokeMethod(
        methodSetAlias, json.encode(getAliasPayload(newUniqueId, appId)));
  }

  @override
  void setUserName(String userName, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameUserName, userAttrTypeGeneral, userName, appId));
  }

  @override
  void setFirstName(String firstName, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameFirstName, userAttrTypeGeneral, firstName, appId));
  }

  @override
  void setLastName(String lastName, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameLastName, userAttrTypeGeneral, lastName, appId));
  }

  @override
  void setEmail(String emailId, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameEmailId, userAttrTypeGeneral, emailId, appId));
  }

  @override
  void setPhoneNumber(String phoneNumber, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNamePhoneNum, userAttrTypeGeneral, phoneNumber, appId));
  }

  @override
  void setGender(MoEGender gender, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(userAttrNameGender, userAttrTypeGeneral,
            genderToString(gender), appId));
  }

  @override
  void setLocation(MoEGeoLocation location, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(userAttrNameLocation, userAttrTypeLocation,
            location.toMap(), appId));
  }

  @override
  void setBirthDate(String birthDate, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameBirtdate, userAttrTypeTimestamp, birthDate, appId));
  }

  @override
  void setUserAttribute(
      String userAttributeName, dynamic userAttributeValue, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttributeName, userAttrTypeGeneral, userAttributeValue, appId));
  }

  @override
  void setUserAttributeIsoDate(
      String userAttributeName, String isoDateString, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttributeName, userAttrTypeTimestamp, isoDateString, appId));
  }

  @override
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location, String appId) {
    _methodChannel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttributeName, userAttrTypeLocation, location.toMap(), appId));
  }

  @override
  void setAppStatus(MoEAppStatus appStatus, String appId) {
    _methodChannel.invokeMethod(
        methodSetAppStatus, json.encode(getAppStatusPayload(appStatus, appId)));
  }

  @override
  void showInApp(String appId) {
    _methodChannel.invokeMethod(
        methodShowInApp, json.encode(getAccountMeta(appId)));
  }

  @override
  void logout(String appId) {
    _methodChannel.invokeMethod(
        methodLogout, json.encode(getAccountMeta(appId)));
  }

  @override
  void getSelfHandledInApp(String appId) {
    _methodChannel.invokeMethod(
        methodSelfHandledInApp, json.encode(getAccountMeta(appId)));
  }

  @override
  void selfHandledCallback(Map<String, dynamic> payload) {
    _methodChannel.invokeMethod(
        methodSelfHandledCallback, json.encode(payload));
  }

  @override
  void setCurrentContext(List<String> contexts, String appId) {
    _methodChannel.invokeMethod(methodSetAppContext,
        json.encode(getInAppContextPayload(contexts, appId)));
  }

  @override
  void resetCurrentContext(String appId) {
    _methodChannel.invokeMethod(
        methodResetAppContext, json.encode(getAccountMeta(appId)));
  }

  @override
  void passPushToken(
      String pushToken, MoEPushService pushService, String appId) {
    _methodChannel.invokeMethod(
        methodPushToken, _getPushTokenPayload(pushToken, pushService, appId));
  }

  @override
  void optOutDataTracking(bool shouldOptOutDataTracking, String appId) {
    _methodChannel.invokeMethod(
        methodOptOutTracking,
        json.encode(getOptOutTrackingPayload(
            gdprOptOutTypeData, shouldOptOutDataTracking, appId)));
  }

  @override
  void registerForPushNotification() {
    Logger.v('registerForPushNotification() method not available for Android');
  }

  @override
  void passPushPayload(
      Map<String, dynamic> payload, MoEPushService pushService, String appId) {
    final String pushPayload = _getPushPayload(payload, pushService, appId);
    _methodChannel.invokeMethod(methodPushPayLoad, pushPayload);
  }

  @override
  void updateSdkState(bool shouldEnableSdk, String appId) {
    _methodChannel.invokeMethod(methodUpdateSdkState,
        json.encode(getUpdateSdkStatePayload(shouldEnableSdk, appId)));
  }

  @override
  void onOrientationChanged() {
    _methodChannel.invokeMethod(methodOnOrientationChanged);
  }

  @override
  void updateDeviceIdentifierTrackingStatus(
      String appId, String identifierType, bool state) {
    _methodChannel.invokeListMethod(methodUpdateDeviceIdentifierTrackingStatus,
        _getDeviceIdentifierJson(appId, identifierType, state));
  }

  @override
  void setupNotificationChannel() {
    _methodChannel.invokeMethod(methodSetupNotificationChannelAndroid);
  }

  @override
  void permissionResponse(bool isGranted, PermissionType type) {
    _methodChannel.invokeMethod(methodPermissionResponse,
        json.encode(getPermissionResponsePayload(isGranted, type)));
  }

  @override
  void navigateToSettings() {
    _methodChannel.invokeMethod(methodNavigateToSettingsAndroid);
  }

  @override
  void requestPushPermissionAndroid() {
    _methodChannel.invokeMethod(methodRequestPushPermissionAndroid);
  }

  @override
  void updatePushPermissionRequestCountAndroid(int requestCount, String appId) {
    _methodChannel.invokeMethod(methodUpdatePushPermissionRequestCount,
        _getUpdatePushCountJsonPayload(requestCount, appId));
  }

  String _getUserAttributePayloadJson(String attributeName,
      String attributeType, dynamic attributeValue, String appId) {
    return json.encode(getUserAttributePayload(
        attributeName, attributeType, attributeValue, appId));
  }

  String _getPushTokenPayload(
      String pushToken, MoEPushService pushService, String appId) {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyData] = {
      keyPushToken: pushToken,
      keyService: pushService.asString
    };
    return json.encode(payload);
  }

  String _getPushPayload(Map<String, dynamic> pushPayload,
      MoEPushService pushService, String appId) {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyData] = {
      keyPayload: pushPayload,
      keyService: pushService.asString
    };
    return json.encode(payload);
  }

  String _getDeviceIdentifierJson(
      String appId, String identifierType, bool state) {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyData] = {identifierType: state};
    return json.encode(payload);
  }

  String _getUpdatePushCountJsonPayload(int requestCount, String appId) {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyData] = {keyUpdatePushPermissionCount: requestCount};
    return jsonEncode(payload);
  }
}
