import 'dart:convert';

import '../internal/constants.dart';
import '../internal/logger.dart';
import '../model/platforms.dart';
import '../model/push/moe_push_service.dart';
import '../model/push/push_campaign.dart';
import '../model/push/push_campaign_data.dart';
import '../model/push/push_token_data.dart';
import 'utils.dart';

/// InApp Json Payload Mapper
class PushPayloadMapper {
  final String _tag = '${TAG}PushPayloadMapper';

  /// Get [PushTokenData] from Json String
  PushTokenData? pushTokenFromJson(dynamic methodCallArgs) {
    try {
      final Map<String, dynamic> tokenData =
          json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
      return PushTokenData(
          PlatformsExtension.fromString(tokenData[keyPlatform].toString()),
          tokenData[keyPushToken].toString(),
          MoEPushServiceExtention.fromString(
              tokenData[keyPushService].toString()));
    } catch (exception, stackTrace) {
      Logger.e('$_tag Error: pushTokenFromJson() : ',
          stackTrace: stackTrace, error: exception);
    }
    return null;
  }

  /// Get [PushCampaignData] from Json String
  PushCampaignData? pushCampaignFromJson(dynamic methodCallArgs) {
    try {
      Logger.v('$_tag pushCampaignFromJson() : $methodCallArgs');
      final Map<String, dynamic> pushCampaignPayload =
          json.decode(methodCallArgs.toString()) as Map<String, dynamic>;
      final Map<String, dynamic> campaignData =
          pushCampaignPayload[keyData] as Map<String, dynamic>;
      return PushCampaignData(
          PlatformsExtension.fromString(campaignData[keyPlatform].toString()),
          accountMetaFromMap(
              pushCampaignPayload[keyAccountMeta] as Map<String, dynamic>),
          PushCampaign(
              (campaignData.containsKey(keyIsDefaultAction)
                  ? campaignData[keyIsDefaultAction]
                  : false) as bool,
              (campaignData.containsKey(keyClickedAction)
                  ? campaignData[keyClickedAction]
                  : <String, dynamic>{}) as Map<String, dynamic>,
              (campaignData.containsKey(keyPayload)
                  ? campaignData[keyPayload]
                  : <String, dynamic>{}) as Map<String, dynamic>,
              (campaignData.containsKey(keySelfHandledPushRedirection)
                  ? campaignData[keySelfHandledPushRedirection]
                  : false) as bool));
    } catch (e, stackTrace) {
      Logger.e('$_tag Error: pushCampaignFromJson() : ',
          stackTrace: stackTrace, error: e);
    }
    return null;
  }
}
