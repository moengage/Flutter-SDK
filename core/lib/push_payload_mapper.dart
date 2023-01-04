import 'dart:convert';

import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/platforms.dart';
import 'package:moengage_flutter/model/push/moe_push_service.dart';
import 'package:moengage_flutter/model/push/push_campaign.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/utils.dart';
import 'package:moengage_flutter/logger.dart';

class PushPayloadMapper {
  final _tag = "${TAG}PushPayloadMapper";

  PushTokenData? pushTokenFromJson(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> tokenData = json.decode(methodCallArgs);
      return PushTokenData(
          PlatformsExtension.fromString(tokenData[keyPlatform]),
          tokenData[keyPushToken],
          MoEPushServiceExtention.fromString(tokenData[keyPushService]));
    } catch (exception,stackTrace) {
      Logger.e("Error: pushTokenFromJson() : ",tag: _tag,stackTrace: stackTrace,error: exception);
    }
    return null;
  }

  PushCampaignData? pushCampaignFromJson(dynamic methodCallArgs) {
    try {
      Logger.d("pushCampaignFromJson() : $methodCallArgs",_tag);
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
    } catch (e,stackTrace) {
      Logger.e("Error: pushTokenFromJson() : ",tag: _tag,stackTrace: stackTrace,error: e);
    }
    return null;
  }
}
