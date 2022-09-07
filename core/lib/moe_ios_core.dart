import 'package:flutter/services.dart';
import 'package:moengage_flutter/utils.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/geo_location.dart';

import 'data_payload_mapper.dart';

class MoEiOSCore {

  MethodChannel _channel;
  MoEiOSCore(this._channel);

  void trackEvent(
      String eventName, MoEProperties eventAttributes, String appId) {
    _channel.invokeMethod(
        methodTrackEvent, getEventPayload(eventName, eventAttributes, appId));
  }

  void setUniqueId(String uniqueId, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameUniqueId, userAttrTypeGeneral, uniqueId, appId));
  }

  void setAlias(String newUniqueId, String appId) {
    _channel.invokeMethod(methodSetAlias, getAliasPayload(newUniqueId, appId));
  }

  void setUserName(String userName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameUserName, userAttrTypeGeneral, userName, appId));
  }

  void setFirstName(String firstName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameFirstName, userAttrTypeGeneral, firstName, appId));
  }

  void setLastName(String lastName, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameLastName, userAttrTypeGeneral, lastName, appId));
  }

  void setEmail(String emailId, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameEmailId, userAttrTypeGeneral, emailId, appId));
  }

  void setPhoneNumber(String phoneNumber, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNamePhoneNum, userAttrTypeGeneral, phoneNumber, appId));
  }

  void setGender(MoEGender gender, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(userAttrNameGender, userAttrTypeGeneral,
            genderToString(gender), appId));
  }

  void setLocation(MoEGeoLocation location, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(userAttrNameLocation, userAttrTypeLocation,
            location.toMap(), appId));
  }

  void setBirthDate(String birthDate, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameBirtdate, userAttrTypeTimestamp, birthDate, appId));
  }

  void setUserAttribute(
      String userAttributeName, dynamic userAttributeValue, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeGeneral, userAttributeValue, appId));
  }

  void setUserAttributeIsoDate(
      String userAttributeName, String isoDateString, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeTimestamp, isoDateString, appId));
  }

  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location, String appId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeLocation, location.toMap(), appId));
  }

  void setAppStatus(MoEAppStatus appStatus, String appId) {
    _channel.invokeListMethod(
        methodSetAppStatus, getAppStatusPayload(appStatus, appId));
  }

  void showInApp(String appId) {
    _channel.invokeMethod(methodShowInApp, getAccountMeta(appId));
  }

  void getSelfHandledInApp(String appId) {
    _channel.invokeMethod(methodSelfHandledInApp, getAccountMeta(appId));
  }

  void selfHandledCallback(Map<String, dynamic> payload) {
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  void setCurrentContext(List<String> contexts, String appId) {
    _channel.invokeMethod(
        methodSetAppContext, getInAppContextPayload(contexts, appId));
  }

  void resetCurrentContext(String appId) {
    _channel.invokeMethod(methodResetAppContext, getAccountMeta(appId));
  }

  void registerForPushNotification() {
    _channel.invokeMethod(methodiOSRegisterPush);
  }

  void startGeofenceMonitoring() {
    _channel.invokeMethod(methodiOSStartGeofence);
  }

  void optOutDataTracking(bool shouldOptOutDataTracking, String appId) {
    _channel.invokeMethod(
        methodOptOutTracking,
        getOptOutTrackingPayload(
            gdprOptOutTypeData, shouldOptOutDataTracking, appId));
  }

  void logout(String appId) {
    _channel.invokeMethod(methodLogout, getAccountMeta(appId));
  }

  void updateSdkState(bool shouldEnableSdk, String appId) {
    _channel.invokeMethod(
        methodUpdateSdkState, getUpdateSdkStatePayload(shouldEnableSdk, appId));
  }
}
