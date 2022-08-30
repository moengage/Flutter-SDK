import 'dart:convert';

import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/platforms.dart';
import 'package:moengage_flutter/model/push/moe_push_service.dart';
import 'package:moengage_flutter/model/push/push_campaign.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/utils.dart';

class PushPayloadMapper {

  String _tag = "${TAG}PushPayloadMapper";
  PushTokenData? pushTokenFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> tokenData = json.decode(methodCallArgs);
      return PushTokenData(
          PlatformsExtension.fromString(tokenData[keyPlatform]),
          PushToken(tokenData[keyPushToken],
              MoEPushServiceExtention.fromString(tokenData[keyPushService])));
    } catch (exception) {
      print("$_tag Error: pushTokenFromJson() : ${exception.toString()}");
    }
    return null;
  }

  PushCampaignData? pushCampaignFromJson(dynamic methodCallArgs) {
    try {
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
