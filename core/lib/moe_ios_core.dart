import 'package:flutter/services.dart';
import 'package:moengage_flutter/utils.dart';
import 'package:moengage_flutter/gender.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/app_status.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/geo_location.dart';

class MoEiOSCore {
  MethodChannel _channel;

  MoEiOSCore(MethodChannel channel) {
    _channel = channel;
  }

  void enableSDKLogs() {
    _channel.invokeMethod(methodEnableSDKLogs);
  }

  void trackEvent(String eventName, MoEProperties eventAttributes) {
    _channel.invokeMethod(
        methodTrackEvent, getEventPayload(eventName, eventAttributes));
  }

  void setUniqueId(String uniqueId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameUniqueId, userAttrTypeGeneral, uniqueId));
  }

  void setAlias(String newUniqueId) {
    _channel.invokeMethod(methodSetAlias, getMap(keyAlias, newUniqueId));
  }

  void setUserName(String userName) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameUserName, userAttrTypeGeneral, userName));
  }

  void setFirstName(String firstName) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameFirstName, userAttrTypeGeneral, firstName));
  }

  void setLastName(String lastName) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameLastName, userAttrTypeGeneral, lastName));
  }

  void setEmail(String emailId) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameEmailId, userAttrTypeGeneral, emailId));
  }

  void setPhoneNumber(String phoneNumber) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNamePhoneNum, userAttrTypeGeneral, phoneNumber));
  }

  void setGender(MoEGender gender) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameGender, userAttrTypeGeneral, genderToString(gender)));
  }

  void setLocation(MoEGeoLocation location) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameLocation, userAttrTypeLocation, location.toMap()));
  }

  void setBirthDate(String birthDate) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttrNameBirtdate, userAttrTypeTimestamp, birthDate));
  }

  void setUserAttribute(String userAttributeName, dynamic userAttributeValue) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeGeneral, userAttributeValue));
  }

  void setUserAttributeIsoDate(String userAttributeName, String isoDateString) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeTimestamp, isoDateString));
  }

  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location) {
    _channel.invokeMethod(
        methodSetUserAttribute,
        getUserAttributePayload(
            userAttributeName, userAttrTypeLocation, location.toMap()));
  }

  void setAppStatus(MoEAppStatus appStatus) {
    _channel.invokeListMethod(
        methodSetAppStatus,
        getMap(
            keyAppStatus,
            appStatus == MoEAppStatus.install
                ? appStatusInstall
                : appStatusUpdate));
  }

  void showInApp() {
    _channel.invokeMethod(methodShowInApp);
  }

  void getSelfHandledInApp() {
    _channel.invokeMethod(methodSelfHandledInApp);
  }

  void selfHandledCallback(Map<String, dynamic> payload) {
    _channel.invokeMethod(methodSelfHandledCallback, payload);
  }

  void setCurrentContext(List<String> contexts) {
    _channel.invokeMethod(methodSetAppContext, getMap(keyContexts, contexts));
  }

  void resetCurrentContext() {
    _channel.invokeMethod(methodResetAppContext);
  }

  void registerForPushNotification() {
    _channel.invokeMethod(methodiOSRegisterPush);
  }

  void startGeofenceMonitoring() {
    _channel.invokeMethod(methodiOSStartGeofence);
  }

  void optOutDataTracking(bool shouldOptOutDataTracking) {
    var optOutPayload =
        getOptOutTrackingPayload(gdprOptOutTypeData, shouldOptOutDataTracking);
    _channel.invokeMethod(methodOptOutTracking, optOutPayload);
  }

  void optOutPushTracking(bool shouldOptOutPushTracking) {
    var optOutPayload =
        getOptOutTrackingPayload(gdprOptOutTypePush, shouldOptOutPushTracking);
    _channel.invokeMethod(methodOptOutTracking, optOutPayload);
  }

  void optOutInAppTracking(bool shouldOptOutInAppTracking) {
    var optOutPayload = getOptOutTrackingPayload(
        gdprOptOutTypeInApp, shouldOptOutInAppTracking);
    _channel.invokeMethod(methodOptOutTracking, optOutPayload);
  }

  void logout() {
    _channel.invokeMethod(methodLogout);
  }
}
