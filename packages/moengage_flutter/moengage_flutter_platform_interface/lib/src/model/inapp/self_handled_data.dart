import '../../model/account_meta.dart';
import '../../model/platforms.dart';
import '../inapp/campaign_data.dart';
import '../inapp/self_handled_campaign.dart';

/// Self Handled InApp Campaign Data
class SelfHandledCampaignData {
  /// [SelfHandledCampaignData] Constructor
  SelfHandledCampaignData(
      this.campaignData, this.accountMeta, this.campaign, this.platform);

  /// Campaign Data of type [CampaignData]
  CampaignData campaignData;

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// Self Handled Campaign Data
  SelfHandledCampaign campaign;

  /// Type of Platform [Android/IOS]
  Platforms platform;

  @override
  String toString() {
    return '{\ncampaignData: $campaignData\naccountMeta: $accountMeta\ncampaign: $campaign\nplatform: ${platform.asString}\n}';
  }
}
