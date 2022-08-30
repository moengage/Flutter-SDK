import 'package:moengage_flutter/model/inapp/campaign_context.dart';

class CampaignData {
  String campaignId;
  String campaignName;
  CampaignContext context;

  CampaignData(this.campaignId, this.campaignName, this.context);

  String toString() {
    return "{\n" +
        "campaignId:" +
        campaignId +
        "\n" +
        "campaignId:" +
        campaignId +
        "\n" +
        "context:" +
        context.toString() +
        "\n" +
        "}";
  }
}
