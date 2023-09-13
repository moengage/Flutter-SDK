import '../../model/account_meta.dart';
import '../../model/platforms.dart';
import '../inapp/action.dart';
import '../inapp/campaign_data.dart';

/// InApp Click Data
class ClickData {
  /// [ClickData] Constructor
  ClickData(this.platform, this.accountMeta, this.campaignData, this.action);

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// InApp Campaign Related Data
  CampaignData campaignData;

  /// InApp Action
  Action action;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: $accountMeta\ncampaignData: $campaignData\naction: $action\n}';
  }
}
