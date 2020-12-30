import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/utils.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/gender.dart';

class MoEWebCore {
  MethodChannel _channel;

  MoEWebCore(MethodChannel channel) {
    _channel = channel;
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
        methodSetUserAttributeTimeStamp,
        _getUserAttributePayloadJSON(
            userAttributeName, userAttrTypeTimestamp, {keyTimeStampWeb: DateTime.parse(isoDateString).millisecondsSinceEpoch.toString()}));
  }

  void logout() {
    _channel.invokeMethod(methodLogout);
  }

  String _getEventPayloadJSON(String eventName, MoEProperties eventAttributes) {
    return json.encode(getEventPayloadWeb(eventName, eventAttributes));
  }

  String _getUserAttributePayloadJSON(
      String attributeName, String attributeType, dynamic attributeValue) {
    return json.encode(
        getUserAttributePayload(attributeName, attributeType, attributeValue));
  }

}