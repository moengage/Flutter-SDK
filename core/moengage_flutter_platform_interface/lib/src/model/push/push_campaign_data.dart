import './push_campaign.dart';
import '../account_meta.dart';
import '../platforms.dart';

class PushCampaignData {
  PushCampaignData(this.platform, this.accountMeta, this.data);
  Platforms platform;
  AccountMeta accountMeta;
  PushCampaign data;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: ${accountMeta.toString()}\ndata: ${data.toString()}\n}';
  }
}
