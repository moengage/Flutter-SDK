import 'dart:convert';

import '../constants.dart';
import '../internal/logger.dart';
import '../model/inapp/action.dart';
import '../model/inapp/campaign_context.dart';
import '../model/inapp/campaign_data.dart';
import '../model/inapp/click_data.dart';
import '../model/inapp/inapp_action_type.dart';
import '../model/inapp/inapp_custom_action.dart';
import '../model/inapp/inapp_data.dart';
import '../model/inapp/navigation_action.dart';
import '../model/inapp/navigation_type.dart';
import '../model/inapp/self_handled_campaign.dart';
import '../model/inapp/self_handled_data.dart';
import '../model/platforms.dart';
import 'utils.dart';

class InAppPayloadMapper {
  final String _tag = '${TAG}InAppPayloadMapper';

  SelfHandledCampaignData? selfHandledCampaignFromJson(dynamic methodCallArgs) {
    try {
      final Map<String, dynamic> selfHandledPayload =
          json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
      final Map<String, dynamic> data =
          selfHandledPayload[keyData] as Map<String, dynamic>;
      return SelfHandledCampaignData(
          campaignDataFromMap(data),
          accountMetaFromMap(
              selfHandledPayload[keyAccountMeta] as Map<String, dynamic>),
          selfHandledCampaignFromMap(
              data[keySelfHandled] as Map<String, dynamic>),
          PlatformsExtension.fromString(data[keyPlatform].toString()));
    } catch (e, stackTrace) {
      Logger.e('$_tag Error: selfHandledCampaignFromJson() :',
          error: e, stackTrace: stackTrace);
    }
    return null;
  }

  InAppData? inAppDataFromJson(dynamic methodCallArgs) {
    try {
      final Map<String, dynamic> inAppDataPayload =
          json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
      final Map<String, dynamic> data =
          inAppDataPayload[keyData] as Map<String, dynamic>;
      return InAppData(
          PlatformsExtension.fromString(data[keyPlatform].toString()),
          accountMetaFromMap(
              inAppDataPayload[keyAccountMeta] as Map<String, dynamic>),
          campaignDataFromMap(data));
    } catch (e, stackTrace) {
      Logger.e('$_tag Error: inAppDataFromJson() :',
          error: e, stackTrace: stackTrace);
    }
    return null;
  }

  ClickData? actionFromJson(dynamic payload) {
    try {
      Logger.i('$_tag actionFromJson() : ${payload.toString()}');

      final Map<String, dynamic> actionPayload =
          json.decode(payload.toString()) as Map<String, dynamic>;
      final Map<String, dynamic> actionData =
          actionPayload[keyData] as Map<String, dynamic>;
      return ClickData(
          PlatformsExtension.fromString(actionData[keyPlatform].toString()),
          accountMetaFromMap(
              actionPayload[keyAccountMeta] as Map<String, dynamic>),
          campaignDataFromMap(actionData),
          actionFromMap(actionData));
    } catch (e, stackTrace) {
      Logger.e('$_tag Error: actionFromJson() :',
          error: e, stackTrace: stackTrace);
    }
    return null;
  }

  Action actionFromMap(Map<String, dynamic> actionData) {
    switch (actionData[keyActionType]) {
      case _actionNavigation:
        return navigationActionFromMap(
            actionData[keyNavigation] as Map<String, dynamic>);
      case _actionCustomAction:
        return customActionFromMap(
            actionData[keyCustomAction] as Map<String, dynamic>);
      default:
        throw Exception('${actionData[keyActionType]} is not a valid action');
    }
  }

  NavigationAction navigationActionFromMap(Map<String, dynamic> actionData) {
    return NavigationAction(
        ActionType.navigation,
        NavigationTypeExtension.fromString(
            actionData[keyNavigationType].toString()),
        actionData[keyValue].toString(),
        actionData[keyKvPair] as Map<String, dynamic>);
  }

  CustomAction customActionFromMap(Map<String, dynamic> actionData) {
    return CustomAction(
        ActionType.custom, actionData[keyKvPair] as Map<String, dynamic>);
  }

  CampaignData campaignDataFromMap(Map<String, dynamic> dataPayload) {
    return CampaignData(
        dataPayload[keyCampaignId].toString(),
        dataPayload[keyCampaignName].toString(),
        campaignContextFromMap(
            dataPayload[keyCampaignContext] as Map<String, dynamic>));
  }

  CampaignContext campaignContextFromMap(Map<String, dynamic> dataPayload) {
    return CampaignContext(
        dataPayload[keyFormattedCampaignId].toString(), dataPayload);
  }

  SelfHandledCampaign selfHandledCampaignFromMap(
      Map<String, dynamic> dataPayload) {
    return SelfHandledCampaign(
        dataPayload[keyPayload].toString(),
        (dataPayload.containsKey(keyDismissInterval)
            ? dataPayload[keyDismissInterval]
            : -1) as int);
  }

  Map<String, dynamic> selfHandleCampaignDataToMap(
      SelfHandledCampaignData campaignData, String actionType) {
    final Map<String, dynamic> payload =
        accountMetaToMap(campaignData.accountMeta);
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

const String _actionNavigation = 'navigation';
const String _actionCustomAction = 'customAction';
