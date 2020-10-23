
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/utils.dart';

import 'app_status.dart';
import 'constants.dart';
import 'gender.dart';
import 'geo_location.dart';

class MoEAndroidCore {

  MethodChannel _channel;

  MoEAndroidCore(MethodChannel channel) {
    _channel = channel;
  }

  void enableSDKLogs() {
    _channel.invokeMethod(methodEnableSDKLogs);
  }

  void trackEvent(String eventName, MoEProperties eventAttributes) {
    _channel.invokeMethod(methodTrackEvent,
        getEventPayloadJSON(eventName, eventAttributes));
  }

  void setUniqueId(String uniqueId) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttrNameUniqueId,
            userAttrTypeGeneral, uniqueId));
  }

  void setAlias(String newUniqueId) {
    _channel.invokeMethod(
        methodSetAlias, json.encode(getMap(keyAlias, newUniqueId)));
  }

   void setUserName(String userName) {
    _channel.invokeMethod(methodSetUserAttribute, getUserAttributePayloadJSON(userAttrNameUserName, userAttrTypeGeneral, userName));
  }
  
  void setFirstName(String firstName) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttrNameFirstName,
            userAttrTypeGeneral, firstName));
  }

  void setLastName(String lastName) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttrNameLastName,
            userAttrTypeGeneral, lastName));
  }

  void setEmail(String emailId) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttrNameEmailId,
            userAttrTypeGeneral, emailId));
  }

  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttrNamePhoneNum,
            userAttrTypeGeneral, phoneNumber));
  }

  void setGender(MoEGender gender) {
      _channel.invokeMethod(methodSetUserAttribute,
          getUserAttributePayloadJSON(userAttrNameGender,
              userAttrTypeGeneral, genderToString(gender)));
  }

  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttrNameLocation,
            userAttrTypeLocation, location.toMap())
    );
  }

  void setBirthDate(String birthDate) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttrNameBirtdate,
            userAttrTypeTimestamp, birthDate));
  }

  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttributeName,
            userAttrTypeGeneral, userAttributeValue));
  }

  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON( userAttributeName,
            userAttrTypeTimestamp, isoDateString));
  }

  void setUserAttributeLocation(String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod(methodSetUserAttribute,
        getUserAttributePayloadJSON(userAttributeName,
            userAttrTypeLocation, location.toMap())
    );
  }

  void setAppStatus(MoEAppStatus appStatus) {
    _channel.invokeListMethod(methodSetAppStatus,
        json.encode(getMap(keyAppStatus,
      appStatus == MoEAppStatus.install ? appStatusInstall : appStatusUpdate)));
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
      json.encode(getMap(keyContexts, contexts)));
  }

  void resetCurrentContext() {
    _channel.invokeMethod(methodResetAppContext);
  }

  void passPushToken(String pushToken) {
    _channel.invokeMethod(
        methodPushToken,
        json.encode(getMap(keyPushToken, pushToken)));
  }

  void passPushPayload(Map<String, String> payload) {
    _channel.invokeMethod(
        methodPushPayLoad,
        json.encode(getMap(keyPushPayload, payload)));
  }

  void optOutDataTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayloadJSON(
        gdprOptOutTypeData, shouldOptOutDataTracking));
  }

  void optOutPushTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayloadJSON(
        gdprOptOutTypePush, shouldOptOutDataTracking));
  }

  void optOutInAppTracking(bool shouldOptOutDataTracking) {
    _channel.invokeMethod(methodOptOutTracking, getOptOutTrackingPayloadJSON(
        gdprOptOutTypeInApp, shouldOptOutDataTracking));
  }
}