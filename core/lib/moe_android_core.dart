import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/utils.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/geo_location.dart';

class MoEAndroidCore {
  MethodChannel _channel;

  MoEAndroidCore(MethodChannel channel) {
    _channel = channel;
  }

  void enableSDKLogs() {
    _channel.invokeMethod(methodEnableSDKLogs);
  }

  void trackEvent(String eventName, MoEProperties eventAttributes) {
    _channel.invokeMethod(
        methodTrackEvent, _getEventPayloadJSON(eventName, eventAttributes));
  }

  void setUniqueId(String uniqueId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameUniqueId, userAttrTypeGeneral, uniqueId));
  }

  void setAlias(String newUniqueId) {
    _channel.invokeMethod(
        methodSetAlias, json.encode(getMap(keyAlias, newUniqueId)));
  }

  void setUserName(String userName) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameUserName, userAttrTypeGeneral, userName));
  }

  void setFirstName(String firstName) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameFirstName, userAttrTypeGeneral, firstName));
  }

  void setLastName(String lastName) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameLastName, userAttrTypeGeneral, lastName));
  }

  void setEmail(String emailId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameEmailId, userAttrTypeGeneral, emailId));
  }

  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNamePhoneNum, userAttrTypeGeneral, phoneNumber));
  }

  void setGender(MoEGender gender) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameGender, userAttrTypeGeneral, genderToString(gender)));
  }

  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameLocation, userAttrTypeLocation, location.toMap()));
  }

  void setBirthDate(String birthDate) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttrNameBirtdate, userAttrTypeTimestamp, birthDate));
  }

  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttributeName, userAttrTypeGeneral, userAttributeValue));
  }

  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttributeName, userAttrTypeTimestamp, isoDateString));
  }

  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        _getUserAttributePayloadJSON(
            userAttributeName, userAttrTypeLocation, location.toMap()));
  }

  void setAppStatus(MoEAppStatus appStatus) {
    _channel.invokeListMethod(
        methodSetAppStatus,
        json.encode(getMap(
            keyAppStatus,
            appStatus == MoEAppStatus.install
                ? appStatusInstall
                : appStatusUpdate)));
  }

  void showInApp() {
    _channel.invokeMethod(methodShowInApp);
  }

  void logout() {
    _channel.invokeMethod(methodLogout);
  }

  void getSelfHandledInApp() {
    _channel.invokeMethod(methodSelfHandledInApp);
  }

  void selfHandledCallback(Map<String, dynamic> payload) {
    _channel.invokeMethod(methodSelfHandledCallback, json.encode(payload));
  }

  void setCurrentContext(List<String> contexts) {
    _channel.invokeMethod(methodSetAppContext,
        json.encode(<String, dynamic>{keyContexts: contexts}));
  }

  void resetCurrentContext() {
    _channel.invokeMethod(methodResetAppContext);
  }

  void passPushToken(String pushToken, String pushService) {
    _channel.invokeMethod(
        methodPushToken, _getPushTokenPayload(pushToken, pushService));
  }

  void passPushPayload(Map<String, dynamic> payload, String pushService) {
    _channel.invokeMethod(
        methodPushPayLoad, _getPushPayload(payload, pushService));
  }

  void optOutDataTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(
        methodOptOutTracking,
        _getOptOutTrackingPayloadJSON(
            gdprOptOutTypeData, shouldOptOutDataTracking));
  }

  void optOutPushTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(
        methodOptOutTracking,
        _getOptOutTrackingPayloadJSON(
            gdprOptOutTypePush, shouldOptOutDataTracking));
  }

  void optOutInAppTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(
        methodOptOutTracking,
        _getOptOutTrackingPayloadJSON(
            gdprOptOutTypeInApp, shouldOptOutDataTracking));
  }

  String _getEventPayloadJSON(String eventName, MoEProperties eventAttributes) {
    return json.encode(getEventPayload(eventName, eventAttributes));
  }

  String _getUserAttributePayloadJSON(
      String attributeName, String attributeType, dynamic attributeValue) {
    return json.encode(
        getUserAttributePayload(attributeName, attributeType, attributeValue));
  }

  String _getOptOutTrackingPayloadJSON(
      String type, bool shouldOptOutDataTracking) {
    return json
        .encode(getOptOutTrackingPayload(type, shouldOptOutDataTracking));
  }

  String _getPushTokenPayload(String pushToken, String pushService) {
    return json.encode({keyPushToken: pushToken, keyPushService: pushService});
  }

  String _getPushPayload(Map<String, dynamic> payload, String pushService) {
    return json.encode({keyPayload: payload, keyPushService: pushService});
  }
}
