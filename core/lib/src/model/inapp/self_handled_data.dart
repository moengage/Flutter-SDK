import '../account_meta.dart';
import '../platforms.dart';
import 'campaign_data.dart';
import 'self_handled_campaign.dart';

class SelfHandledCampaignData {
  CampaignData campaignData;
  AccountMeta accountMeta;
  SelfHandledCampaign campaign;
  Platforms platform;

  SelfHandledCampaignData(
      this.campaignData, this.accountMeta, this.campaign, this.platform);

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
