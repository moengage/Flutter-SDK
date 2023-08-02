import '../inapp/campaign_context.dart';

class CampaignData {
  CampaignData(this.campaignId, this.campaignName, this.context);
  String campaignId;
  String campaignName;
  CampaignContext context;

  @override
  String toString() {
    return '{\ncampaignId: $campaignId\ncampaignName: $campaignName\ncontext: ${context.toString()}\n}';
  }
}
