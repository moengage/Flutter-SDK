import 'campaign_context.dart';

/// InApp Campaign Data
class CampaignData {
  /// [CampaignData] Constructor
  CampaignData(this.campaignId, this.campaignName, this.context);

  /// InApp Campaign Id
  String campaignId;

  /// InApp Campaign Name
  String campaignName;

  /// Campaign Context of type [CampaignContext]
  CampaignContext context;

  @override
  String toString() {
    return '{\ncampaignId: $campaignId\ncampaignName: $campaignName\ncontext: $context\n}';
  }
}
