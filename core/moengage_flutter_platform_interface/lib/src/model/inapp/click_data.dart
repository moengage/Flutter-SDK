import '../../model/account_meta.dart';
import '../../model/platforms.dart';
import '../inapp/action.dart';
import '../inapp/campaign_data.dart';

class ClickData {
  ClickData(this.platform, this.accountMeta, this.campaignData, this.action);
  Platforms platform;
  AccountMeta accountMeta;
  CampaignData campaignData;
  Action action;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: ${accountMeta.toString()}\ncampaignData: ${campaignData.toString()}\naction: ${action.toString()}\n}';
  }
}
