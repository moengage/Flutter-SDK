import 'package:moengage_flutter/model/account_meta.dart';
import 'package:moengage_flutter/model/inapp/campaign_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_campaign.dart';
import 'package:moengage_flutter/model/platforms.dart';


class SelfHandledCampaignData {
  CampaignData campaignData;
  AccountMeta accountMeta;
  SelfHandledCampaign campaign;
  Platforms platform;

  SelfHandledCampaignData(this.campaignData, this.accountMeta, this.campaign, this.platform);

  String toString() {
    return "{\n" +
        "campaignData: ${campaignData.toString()}" +
        "\n" +
        "accountMeta: ${accountMeta.toString()}" +
        "\n" +
        "campaign: ${campaign.toString()}" +
        "\n" +
        "platform: ${platform.asString}" +
        "\n" +
        "}";
  }
}