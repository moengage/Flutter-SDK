import 'dart:convert';

import 'constants.dart';
import 'internal/logger.dart';
import 'model/inapp/action.dart';
import 'model/inapp/campaign_context.dart';
import 'model/inapp/campaign_data.dart';
import 'model/inapp/click_data.dart';
import 'model/inapp/inapp_action_type.dart';
import 'model/inapp/inapp_custom_action.dart';
import 'model/inapp/inapp_data.dart';
import 'model/inapp/navigation_action.dart';
import 'model/inapp/navigation_type.dart';
import 'model/inapp/self_handled_campaign.dart';
import 'model/inapp/self_handled_data.dart';
import 'model/platforms.dart';
import 'utils.dart';

class InAppPayloadMapper {
  final _tag = "${TAG}InAppPayloadMapper";

  SelfHandledCampaignData? selfHandledCampaignFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> selfHandledPayload = json.decode(methodCallArgs);
      Map<String, dynamic> data = selfHandledPayload[keyData];
      return SelfHandledCampaignData(
          campaignDataFromMap(data),
          accountMetaFromMap(selfHandledPayload[keyAccountMeta]),
          selfHandledCampaignFromMap(data[keySelfHandled]),
          PlatformsExtension.fromString(data[keyPlatform]));
    } catch (e, stackTrace) {
      Logger.e("$_tag Error: selfHandledCampaignFromJson() :",
          error: e, stackTrace: stackTrace);
    }
    return null;
  }

  InAppData? inAppDataFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> inAppDataPayload = json.decode(methodCallArgs);
      Map<String, dynamic> data = inAppDataPayload[keyData];
      return InAppData(
          PlatformsExtension.fromString(data[keyPlatform]),
          accountMetaFromMap(inAppDataPayload[keyAccountMeta]),
          campaignDataFromMap(data));
    } catch (e, stackTrace) {
      Logger.e("$_tag Error: inAppDataFromJson() :",
          error: e, stackTrace: stackTrace);
    }
    return null;
  }

  ClickData? actionFromJson(dynamic payload) {
    try {
      Logger.i("$_tag actionFromJson() : ${payload.toString()}");

      Map<String, dynamic> actionPayload = json.decode(payload);
      Map<String, dynamic> actionData = actionPayload[keyData];
      return ClickData(
          PlatformsExtension.fromString(actionData[keyPlatform]),
          accountMetaFromMap(actionPayload[keyAccountMeta]),
          campaignDataFromMap(actionData),
          actionFromMap(actionData));
    } catch (e, stackTrace) {
      Logger.e("$_tag Error: actionFromJson() :",
          error: e, stackTrace: stackTrace);
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
        throw Exception("${actionData[keyActionType]} is not a valid action");
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
    return CustomAction(ActionType.custom, actionData[keyKvPair]);
  }

  CampaignData campaignDataFromMap(Map<String, dynamic> dataPayload) {
    return CampaignData(
        dataPayload[keyCampaignId],
        dataPayload[keyCampaignName],
        campaignContextFromMap(dataPayload[keyCampaignContext]));
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
            : -1);
  }

  Map<String, dynamic> selfHandleCampaignDataToMap(
      SelfHandledCampaignData campaignData, String actionType) {
    Map<String, dynamic> payload = accountMetaToMap(campaignData.accountMeta);
    payload[keyData] = {
      keyType: actionType,
      keyCampaignName: campaignData.campaignData.campaignName,
      keyCampaignId: campaignData.campaignData.campaignId,
      keyCampaignContext: campaignData.campaignData.context.attributes,
      keySelfHandled: selfHandleCampaignToMap(campaignData.campaign),
      keyPlatform: getPlatform()
    };

    return payload;
  }

  Map<String, dynamic> selfHandleCampaignToMap(
      SelfHandledCampaign selfHandledCampaign) {
    return {
      keyPayload: selfHandledCampaign.payload,
      keyDismissInterval: selfHandledCampaign.dismissInterval
    };
  }
}

const String _actionNavigation = "navigation";
const String _actionCustomAction = "customAction";
