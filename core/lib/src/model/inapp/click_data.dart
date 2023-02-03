import '../account_meta.dart';
import '../platforms.dart';
import 'action.dart';
import 'campaign_data.dart';

class ClickData {
  Platforms platform;
  AccountMeta accountMeta;
  CampaignData campaignData;
  Action action;

  ClickData(this.platform, this.accountMeta, this.campaignData, this.action);

  String toString() {
    return "{\n" +
        "platform: ${platform.asString}" +
        "\n" +
        "accountMeta: ${accountMeta.toString()}" +
        "\n" +
        "campaignData: ${campaignData.toString()}" +
        "\n" +
        "action: ${action.toString()}" +
        "\n" +
        "}";
  }
}
