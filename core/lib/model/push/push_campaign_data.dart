import 'package:moengage_flutter/model/account_meta.dart';
import 'package:moengage_flutter/model/platforms.dart';
import 'package:moengage_flutter/model/push/push_campaign.dart';

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
