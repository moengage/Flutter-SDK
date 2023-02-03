import 'dart:convert';

import 'constants.dart';
import 'model/platforms.dart';
import 'model/push/moe_push_service.dart';
import 'model/push/push_campaign.dart';
import 'model/push/push_campaign_data.dart';
import 'model/push/push_token_data.dart';
import 'utils.dart';

class PushPayloadMapper {
  String _tag = "${TAG}PushPayloadMapper";

  PushTokenData? pushTokenFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> tokenData = json.decode(methodCallArgs);
      return PushTokenData(
          PlatformsExtension.fromString(tokenData[keyPlatform]),
          tokenData[keyPushToken],
          MoEPushServiceExtention.fromString(tokenData[keyPushService]));
    } catch (exception) {
      print("$_tag Error: pushTokenFromJson() : ${exception.toString()}");
    }
    return null;
  }

  PushCampaignData? pushCampaignFromJson(dynamic methodCallArgs) {
    try {
      print("$_tag pushCampaignFromJson() : $methodCallArgs");
      Map<String, dynamic> pushCampaignPayload = json.decode(methodCallArgs);
      Map<String, dynamic> campaignData = pushCampaignPayload[keyData];
      return PushCampaignData(
          PlatformsExtension.fromString(campaignData[keyPlatform]),
          accountMetaFromMap(pushCampaignPayload[keyAccountMeta]),
          PushCampaign(
              campaignData.containsKey(keyIsDefaultAction)
                  ? campaignData[keyIsDefaultAction]
                  : false,
              campaignData.containsKey(keyClickedAction)
                  ? campaignData[keyClickedAction]
                  : new Map(),
              campaignData.containsKey(keyPayload)
                  ? campaignData[keyPayload]
                  : new Map()));
    } catch (e) {
      print("$_tag Error: pushCampaignFromJson() : $e");
    }
    return null;
  }
}
