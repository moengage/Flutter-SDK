
import '../../moengage_flutter_platform_interface.dart';

/// Data for multiple Self Handled InApp Campaigns
class SelfHandledCampaignsData {

  /// Creates an instance of [SelfHandledCampaignsData] with the provided [accountMeta] and [campaigns]
  SelfHandledCampaignsData(this.accountMeta,this.campaigns);

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// List of [SelfHandledCampaignData] to be sent as part of callback to the client
  List<SelfHandledCampaignData> campaigns;

  @override
  String toString() {
    return 'SelfHandledCampaignsData{accountMeta: $accountMeta, campaigns: $campaigns}';
  }
}