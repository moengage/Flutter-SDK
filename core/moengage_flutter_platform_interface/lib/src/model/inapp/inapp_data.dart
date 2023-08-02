import '../../model/account_meta.dart';
import '../../model/inapp/campaign_data.dart';
import '../../model/platforms.dart';

class InAppData {
  InAppData(this.platform, this.accountMeta, this.campaignData);
  Platforms platform;
  AccountMeta accountMeta;
  CampaignData campaignData;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: $accountMeta\ncampaignData: $campaignData\n}';
  }
}
