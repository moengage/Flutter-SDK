import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/utils.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/model/geo_location.dart';
import 'package:moengage_flutter/model/push/moe_push_service.dart';


class MoEAndroidCore {

  MethodChannel _channel;
  MoEAndroidCore(this._channel);

  void trackEvent(
      String eventName, MoEProperties eventAttributes, String appId) {
    _channel.invokeMethod(methodTrackEvent,
        json.encode(getEventPayload(eventName, eventAttributes, appId)));
  }

  void setUniqueId(String uniqueId, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameUniqueId, userAttrTypeGeneral, uniqueId, appId));
  }

  void setAlias(String alias, String appId) {
    _channel.invokeMethod(
        methodSetAlias, json.encode(getAliasPayload(alias, appId)));
  }

  void setUserName(String userName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameUserName, userAttrTypeGeneral, userName, appId));
  }

  void setFirstName(String firstName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameFirstName, userAttrTypeGeneral, firstName, appId));
  }

  void setLastName(String lastName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameLastName, userAttrTypeGeneral, lastName, appId));
  }

  void setEmail(String emailId, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameEmailId, userAttrTypeGeneral, emailId, appId));
  }

  void setPhoneNumber(String phoneNumber, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNamePhoneNum, userAttrTypeGeneral, phoneNumber, appId));
  }

  void setGender(MoEGender gender, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(userAttrNameGender, userAttrTypeGeneral,
            genderToString(gender), appId));
  }

  void setLocation(MoEGeoLocation location, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(userAttrNameLocation, userAttrTypeLocation,
            location.toMap(), appId));
  }

  void setBirthDate(String birthDate, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttrNameBirtdate, userAttrTypeTimestamp, birthDate, appId));
  }

  void setUserAttribute(
      String userAttributeName, dynamic userAttributeValue, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttributeName, userAttrTypeGeneral, userAttributeValue, appId));
  }

  void setUserAttributeIsoDate(
      String userAttributeName, String isoDateString, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttributeName, userAttrTypeTimestamp, isoDateString, appId));
  }

  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJson(
            userAttributeName, userAttrTypeLocation, location.toMap(), appId));
  }

  void setAppStatus(MoEAppStatus appStatus, String appId) {
    _channel.invokeMethod(
        methodSetAppStatus, json.encode(getAppStatusPayload(appStatus, appId)));
  }

  void showInApp(String appId) {
    _channel.invokeMethod(methodShowInApp, json.encode(getAccountMeta(appId)));
  }

  void logout(String appId) {
    _channel.invokeMethod(methodLogout, json.encode(getAccountMeta(appId)));
  }

  void getSelfHandledInApp(String appId) {
    _channel.invokeMethod(
        methodSelfHandledInApp, json.encode(getAccountMeta(appId)));
  }

  void selfHandledCallback(Map<String, dynamic> payload) {
    _channel.invokeMethod(methodSelfHandledCallback, json.encode(payload));
  }

  void setCurrentContext(List<String> contexts, String appId) {
    _channel.invokeMethod(methodSetAppContext,
        json.encode(getInAppContextPayload(contexts, appId)));
  }

  void resetCurrentContext(String appId) {
    _channel.invokeMethod(
        methodResetAppContext, json.encode(getAccountMeta(appId)));
  }

  void passPushToken(
      String pushToken, MoEPushService pushService, String appId) {
    _channel.invokeMethod(
        methodPushToken, _getPushTokenPayload(pushToken, pushService, appId));
  }

  void passPushPayload(
      Map<String, dynamic> payload, MoEPushService pushService, String appId) {
    _channel.invokeMethod(
        methodPushPayLoad, _getPushPayload(payload, pushService, appId));
  }

  void optOutDataTracking(bool shouldOptOutDataTracking, String appId) {
    _channel.invokeMethod(
        methodOptOutTracking,
        json.encode(getOptOutTrackingPayload(
            gdprOptOutTypeData, shouldOptOutDataTracking, appId)));
  }

  void updateSdkState(bool shouldEnableSdk, String appId) {
    _channel.invokeMethod(methodUpdateSdkState,
        json.encode(getUpdateSdkStatePayload(shouldEnableSdk, appId)));
  }

  String _getUserAttributePayloadJson(String attributeName,
      String attributeType, dynamic attributeValue, String appId) {
    return json.encode(getUserAttributePayload(
        attributeName, attributeType, attributeValue, appId));
  }

  String _getPushTokenPayload(
      String pushToken, MoEPushService pushService, String appId) {
    Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyData] = {
      keyPushToken: pushToken,
      keyService: pushService.asString
    };
    return json.encode(payload);
  }

  String _getPushPayload(
      Map<String, dynamic> payload, MoEPushService pushService, String appId) {
    Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyData] = {keyPayload: payload, keyService: pushService.asString};
    return json.encode(payload);
  }

  void onOrientationChanged() {
    _channel.invokeMethod(methodOnOrientationChanged);
  }
}
