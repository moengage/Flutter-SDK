import './push_campaign.dart';
import '../account_meta.dart';
import '../platforms.dart';

/// Push Campaign Related Data
class PushCampaignData {
  /// [PushCampaignData] Constructor
  PushCampaignData(this.platform, this.accountMeta, this.data);

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// [PushCampaign] Data
  PushCampaign data;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: $accountMeta\ndata: $data\n}';
  }
}
