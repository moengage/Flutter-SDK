import 'dart:convert';

import '../internal/constants.dart';
import '../internal/logger.dart';
import '../model/account_meta.dart';
import '../model/inapp/action.dart';
import '../model/inapp/campaign_context.dart';
import '../model/inapp/campaign_data.dart';
import '../model/inapp/click_data.dart';
import '../model/inapp/display_rules.dart';
import '../model/inapp/inapp_action_type.dart';
import '../model/inapp/inapp_custom_action.dart';
import '../model/inapp/inapp_data.dart';
import '../model/inapp/navigation_action.dart';
import '../model/inapp/navigation_type.dart';
import '../model/inapp/self_handled_campaign.dart';
import '../model/inapp/self_handled_campaigns_data.dart';
import '../model/inapp/self_handled_data.dart';
import '../model/platforms.dart';
import 'utils.dart';

/// InApp Json Payload Mapper
class InAppPayloadMapper {
  final String _tag = '${TAG}InAppPayloadMapper';

  /// Get [SelfHandledCampaignData] from JSON String
  SelfHandledCampaignData? selfHandledCampaignFromJson(dynamic methodCallArgs) {
    try {
      final Map<String, dynamic> selfHandledPayload =
          json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
      final Map<String, dynamic> data =
          selfHandledPayload[keyData] as Map<String, dynamic>;
      if (data.isEmpty) {
        Logger.d(
            '$_tag selfHandledCampaignFromJson() : SelfHandled InApp Data is Null');
        return null;
      }
      return selfHandledCampaignDataFromMap(selfHandledPayload);
    } catch (e, stackTrace) {
      Logger.e('$_tag Error: selfHandledCampaignFromJson() :',
          error: e, stackTrace: stackTrace);
    }
    return null;
  }

  /// Get [InAppData] from JSON String
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

  /// Get [ClickData] from JSON String
  ClickData? actionFromJson(dynamic payload) {
    try {
      Logger.i('$_tag actionFromJson() : $payload');

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

  /// Get [Action] from [Map]
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

  /// Get [NavigationAction] from [Map]
  NavigationAction navigationActionFromMap(Map<String, dynamic> actionData) {
    return NavigationAction(
        ActionType.navigation,
        NavigationTypeExtension.fromString(
            actionData[keyNavigationType].toString()),
        actionData[keyValue].toString(),
        actionData[keyKvPair] as Map<String, dynamic>);
  }

  /// Get [CustomAction] from [Map]
  CustomAction customActionFromMap(Map<String, dynamic> actionData) {
    return CustomAction(ActionType.custom,
        castOrFallback(actionData[keyKvPair], <String, dynamic>{}));
  }

  /// Get [CampaignData] from [Map]
  CampaignData campaignDataFromMap(Map<String, dynamic> dataPayload) {
    return CampaignData(
        dataPayload[keyCampaignId].toString(),
        dataPayload[keyCampaignName].toString(),
        campaignContextFromMap(castOrFallback(
            dataPayload[keyCampaignContext], <String, dynamic>{})));
  }

  /// Get [CampaignContext] from [Map]
  CampaignContext campaignContextFromMap(Map<String, dynamic> dataPayload) {
    return CampaignContext(
        dataPayload[keyFormattedCampaignId].toString(), dataPayload);
  }

  /// Get [SelfHandledCampaign] from [Map]
  SelfHandledCampaign selfHandledCampaignFromMap(
      Map<String, dynamic> dataPayload) {
    return SelfHandledCampaign(
        dataPayload[keyPayload].toString(),
        (dataPayload.containsKey(keyDismissInterval)
            ? dataPayload[keyDismissInterval]
            : -1) as int,
        Rules.fromJson((dataPayload[keyDisplayRules] ?? <String, dynamic>{})
            as Map<String, dynamic>));
  }

  /// Convert [SelfHandledCampaign] to [Map] for given ActionType
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
      keyPlatform: getPlatform(),
    };

    return payload;
  }

  /// Convert [SelfHandledCampaign] to [Map]
  Map<String, dynamic> selfHandleCampaignToMap(
      SelfHandledCampaign selfHandledCampaign) {
    return {
      keyPayload: selfHandledCampaign.payload,
      keyDismissInterval: selfHandledCampaign.dismissInterval,
      keyDisplayRules: displayRulesToMap(selfHandledCampaign.displayRules)
    };
  }

  /// Get [SelfHandledCampaignData] from [data] provided the [accountMeta]
  SelfHandledCampaignData selfHandledCampaignDataFromMap(
      Map<String, dynamic> data) {
    return SelfHandledCampaignData(
        campaignDataFromMap(data[keyData] as Map<String, dynamic>),
        accountMetaFromMap(data[keyAccountMeta] as Map<String, dynamic>),
        selfHandledCampaignFromMap(
            data[keyData][keySelfHandled] as Map<String, dynamic>),
        PlatformsExtension.fromString(data[keyData][keyPlatform].toString()));
  }

  /// Get [SelfHandledCampaignsData] from JSON String
  SelfHandledCampaignsData selfHandledCampaignsDataFromJson(
      dynamic data, String appId) {
    try {
      final Map<String, dynamic> selfHandledInAppsPayload =
          json.decode(data.toString()) as Map<String, dynamic>;
      final accountMeta = accountMetaFromMap(
          selfHandledInAppsPayload[keyAccountMeta] as Map<String, dynamic>);
      final campaigns = (selfHandledInAppsPayload[keyCampaigns] as List)
          .map((e) => selfHandledCampaignDataFromMap(e as Map<String, dynamic>))
          .toList();
      return SelfHandledCampaignsData(
          accountMeta: accountMeta, campaigns: campaigns);
    } catch (e) {
      Logger.e('$_tag Error: selfHandledCampaignsFromJson() :', error: e);
      return SelfHandledCampaignsData(
          accountMeta: AccountMeta(appId), campaigns: []);
    }
  }

  /// Convert [SelfHandledCampaign] to [Map]
  Map<String, dynamic> displayRulesToMap(Rules rules) {
    return {keyScreenName: rules.screenName, keyContexts: rules.context};
  }
}

const String _actionNavigation = 'navigation';
const String _actionCustomAction = 'customAction';
