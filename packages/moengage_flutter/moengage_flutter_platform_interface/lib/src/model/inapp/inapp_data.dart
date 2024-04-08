import '../../model/account_meta.dart';
import 'campaign_data.dart';
import '../platforms.dart';

/// InApp Data
class InAppData {
  /// [InAppData] Constructor
  InAppData(this.platform, this.accountMeta, this.campaignData);

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// InApp Campaign Related Data
  CampaignData campaignData;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: $accountMeta\ncampaignData: $campaignData\n}';
  }
}
