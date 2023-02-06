import '../account_meta.dart';
import '../platforms.dart';
import 'push_campaign.dart';

class PushCampaignData {
  Platforms platform;
  AccountMeta accountMeta;
  PushCampaign data;

  PushCampaignData(this.platform, this.accountMeta, this.data);

  @override
  String toString() {
    return "{\n" +
        "platform: ${platform.asString}" +
        "\n" +
        "accountMeta: ${accountMeta.toString()}" +
        "\n" +
        "data: ${data.toString()}" +
        "\n" +
        "}";
  }
}
