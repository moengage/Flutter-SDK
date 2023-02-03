import '../account_meta.dart';
import '../platforms.dart';
import 'campaign_data.dart';

class InAppData {
  Platforms platform;
  AccountMeta accountMeta;
  CampaignData campaignData;

  InAppData(this.platform, this.accountMeta, this.campaignData);

  String toString() {
    return "{" +
        "\n" +
        "platform: ${platform.asString}" +
        "\n" +
        "accountMeta: ${accountMeta.toString()}" +
        "\n" +
        "campaignData: ${campaignData.toString()}" +
        "\n" +
        "}";
  }
}
