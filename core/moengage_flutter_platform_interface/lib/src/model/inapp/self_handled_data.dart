import '../../model/account_meta.dart';
import '../../model/platforms.dart';
import '../inapp/campaign_data.dart';
import '../inapp/self_handled_campaign.dart';

class SelfHandledCampaignData {
  SelfHandledCampaignData(
      this.campaignData, this.accountMeta, this.campaign, this.platform);
  CampaignData campaignData;
  AccountMeta accountMeta;
  SelfHandledCampaign campaign;
  Platforms platform;

  @override
  String toString() {
    return '{\ncampaignData: ${campaignData.toString()}\naccountMeta: ${accountMeta.toString()}\ncampaign: ${campaign.toString()}\nplatform: ${platform.asString}\n}';
  }
}
