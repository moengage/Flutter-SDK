import 'dart:convert';

import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/inapp/action.dart';
import 'package:moengage_flutter/model/inapp/campaign_context.dart';
import 'package:moengage_flutter/model/inapp/campaign_data.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_action_type.dart';
import 'package:moengage_flutter/model/inapp/inapp_custom_action.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/navigation_action.dart';
import 'package:moengage_flutter/model/inapp/navigation_type.dart';
import 'package:moengage_flutter/model/inapp/self_handled_campaign.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/platforms.dart';
import 'package:moengage_flutter/utils.dart';

class InAppPayloadMapper {
  SelfHandledCampaignData? selfHandledCampaignFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> selfHandledPayload = json.decode(methodCallArgs);
      Map<String, dynamic> campaignData = selfHandledPayload[keyData];
      return SelfHandledCampaignData(
          campaignDataFromMap(campaignData),
          selfHandledPayload[keyAccountMeta],
          selfHandledCampaignFromMap(campaignData[keySelfHandled]),
          PlatformsExtension.fromString(campaignData[keyPlatform]));
    } catch (e) {}
    return null;
  }

  InAppData? inAppDataFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> inAppDataPayload = json.decode(methodCallArgs);
      Map<String, dynamic> campaignData = inAppDataPayload[keyData];
      return InAppData(
          PlatformsExtension.fromString(campaignData[keyPlatform]),
          accountMetaFromMap(inAppDataPayload[keyAccountMeta]),
          campaignDataFromMap(campaignData));
    } catch (e) {
      print(e);
    }
    return null;
  }

  ClickData? actionFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> actionPayload = json.decode(methodCallArgs);
      Map<String, dynamic> actionData = actionPayload[keyData];
      return ClickData(
          PlatformsExtension.fromString(actionData[keyPlatform]),
          accountMetaFromMap(actionPayload[keyAccountMeta]),
          campaignDataFromMap(actionData),
          actionFromMap(actionData));
    } catch (e) {
      print(e);
    }
    return null;
  }

  Action actionFromMap(Map<String, dynamic> actionData) {
    switch (actionData[keyActionType]) {
      case _actionNavigation:
        return navigationActionFromMap(actionData[keyNavigation]);
      case _actionCustomAction:
        return customActionFromMap(actionData[keyCustomAction]);
      default:
        throw Exception("Not a valid action");
    }
  }

  NavigationAction navigationActionFromMap(Map<String, dynamic> actionData) {
    return NavigationAction(
        ActionType.navigation,
        NavigationTypeExtension.fromString(actionData[keyNavigationType]),
        actionData[keyValue],
        actionData[keyKvPair]);
  }

  CustomAction customActionFromMap(Map<String, dynamic> actionData) {
    Map<String, dynamic> customActionData = actionData[keyCustomAction];
    return CustomAction(ActionType.custom, customActionData[keyKvPair]);
  }

  CampaignData campaignDataFromMap(Map<String, dynamic> dataPayload) {
    return CampaignData(dataPayload[keyCampaignId], dataPayload[keyCampaignName],
        dataPayload[keyCampaignContext]);
  }

  CampaignContext campaignContextFromMap(Map<String, dynamic> dataPayload) {
    return CampaignContext(dataPayload[keyFormattedCampaignId], dataPayload);
  }

  SelfHandledCampaign selfHandledCampaignFromMap(
      Map<String, dynamic> dataPayload) {
    return SelfHandledCampaign(
        dataPayload[keyPayload],
        dataPayload.containsKey(keyDismissInterval)
            ? dataPayload[keyDismissInterval]
            : -1,
        dataPayload[keyIsCancellable]);
  }

}
const String _actionNavigation = "navigation";
const String _actionCustomAction = "customAction";
