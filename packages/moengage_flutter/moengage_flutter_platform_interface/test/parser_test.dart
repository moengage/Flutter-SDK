import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'package:moengage_flutter_platform_interface/src/utils/push_payload_mapper.dart';
import 'compator.dart';
import 'data_provider/data_provider.dart';
import 'data_provider/json_data.dart';

void main() {
  test('Test Init Payload', () {
    expect(InitConfigPayloadMapper().getInitPayload('', moEInitConfig),
        jsonDecode(initPayload));
  });

  test('Test Event Tracking Payload', () {
    expect(getEventPayload('add_to_cart', properties, ''),
        jsonDecode(eventTrackingPayload));
  });

  test('Test User Attribute Payload', () {
    expect(
        getUserAttributePayload(
            userAttrNameUserName, 'general', 'user1234', ''),
        jsonDecode(userNamePayload));
    expect(getUserAttributePayload(userAttrNameUniqueId, 'general', '1234', ''),
        jsonDecode(uniqueIdPayload));
    expect(
        getUserAttributePayload(userAttrNameFirstName, 'general', 'Mark', ''),
        jsonDecode(firstNamePayload));
    expect(getUserAttributePayload(userAttrNameLastName, 'general', 'Wood', ''),
        jsonDecode(lastNamePayload));
    expect(
        getUserAttributePayload(
            userAttrNameBirtdate, 'general', '2019-12-02T08:26:21.170Z', ''),
        jsonDecode(birthDayPayload));
    expect(
        getUserAttributePayload(
            userAttrNameEmailId, 'general', 'abc@gmail.com', ''),
        jsonDecode(emailIdPayload));
    expect(
        getUserAttributePayload(
            userAttrNamePhoneNum, 'general', '9876543210', ''),
        jsonDecode(mobileNumberPayload));
    expect(getUserAttributePayload(userAttrNameGender, 'general', 'female', ''),
        jsonDecode(genderPayload));
    expect(
        getUserAttributePayload(userAttrNameLocation, 'location',
            MoEGeoLocation(12.1, 77.18).toMap(), ''),
        jsonDecode(locationPayload));
    expect(getUserAttributePayload('language', 'general', 'English', ''),
        jsonDecode(userAttrPayload));
    expect(
        getUserAttributePayload(
            'timeStamp', 'timestamp', '2019-12-02T08:26:21.170Z', ''),
        jsonDecode(timeStampPayload));
    expect(
        getUserAttributePayload(
            'string-array', 'general', ['array', 'of', 'strings'], ''),
        jsonDecode(userAttrStringArrayPayload));
    expect(
        getUserAttributePayload('number-array', 'general', [1.5, 1, 2.56], ''),
        jsonDecode(userAttrNumberArrayPayload));
    expect(
        getUserAttributePayload('json-object', 'general', {'key': 'value'}, ''),
        jsonDecode(userAttrJsonObjectPayload));
    expect(
        getUserAttributePayload(
            'array-of-json-objects',
            'general',
            [
              {'key': '1'},
              {'key': '2'}
            ],
            ''),
        jsonDecode(userAttrArrayOfJsonObjectPayload));
  });

  test('Test Alias Payload', () {
    expect(getAliasPayload('1234', ''), jsonDecode(aliasPayload));
  });

  test('Test App Status Payload', () {
    expect(getAppStatusPayload(MoEAppStatus.install, ''),
        jsonDecode(appStatusPayload));
  });

  test('Test InApp Context Payload', () {
    expect(getInAppContextPayload(['home', 'dashboard'], ''),
        jsonDecode(inAppContextPayload));
  });

  test('Test OptOut Tracking Payload', () {
    expect(getOptOutTrackingPayload(gdprOptOutTypeData, false, ''),
        jsonDecode(optOutTrackingPayload));
  });

  test('Test Update SDK State Payload', () {
    expect(
        getUpdateSdkStatePayload(false, ''), jsonDecode(updateSdkStatePayload));
  });

  test('Push Permission Payload', () {
    expect(getPermissionResponsePayload(false, PermissionType.PUSH),
        jsonDecode(permissionStatePayload));
  });

  test('Push Token Payload', () {
    expect(
        Comparator().isPushTokenDataEqual(
            PushPayloadMapper().pushTokenFromJson(pushServicePayload),
            tokenData),
        true);
  });

  test('Push Campaign Payload', () {
    expect(
        Comparator().isPushCampaignDataEqual(
            PushPayloadMapper().pushCampaignFromJson(pushCampaignPayload),
            pushCampaignData),
        true);
  });

  test('InApp Data Action Test', () {
    expect(
        Comparator().isInAppDataEqual(
            InAppPayloadMapper().inAppDataFromJson(inAppPayload), inAppData),
        true);
  });

  test('Self Handled InApp Payload', () {
    expect(
        Comparator().isSelfHandledDataEqual(
            InAppPayloadMapper()
                .selfHandledCampaignFromJson(selfHandledPayload),
            selfHandledCampaign),
        true);
  });

  test('Self Handled InApp Payload', () {
    expect(
        jsonEncode(InAppPayloadMapper()
                .selfHandleCampaignDataToMap(selfHandledCampaign, 'click')) ==
            inAppClickData,
        true);
  });

  test('InApp Click Action', () {
    expect(
        Comparator().isClickDataEqual(
            InAppPayloadMapper().actionFromJson(inAppClickDataPayload),
            clickData),
        true);
  });

  test('Nudge JSON Payload', () {
    expect(getShowNudgeJsonPayload(MoEngageNudgePosition.bottom, '1234'),
        jsonDecode(nudgePayload));
  });

  test('Multiple Self Handled Payload', () {
    expect(
        Comparator().isSelfHandledCampaignsDataEqual(
            InAppPayloadMapper().selfHandledCampaignsDataFromJson(
                multipleSelfHandledPayload, ''),
            selfHandledCampaigns),
        true);
  });
}
