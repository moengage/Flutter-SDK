import 'package:moengage_flutter/model/account_meta.dart';
import 'package:moengage_flutter/model/inapp/action.dart';
import 'package:moengage_flutter/model/inapp/campaign_data.dart';
import 'package:moengage_flutter/model/platforms.dart';

class ClickData {
  Platforms platform;
  AccountMeta accountMeta;
  CampaignData campaignData;
  Action action;

  ClickData(this.platform, this.accountMeta, this.campaignData, this.action);
  
  String toString() {
    return "{\n" +
        "platform:" +
        platform.asString +
        "\n" +
        "accountMeta:" +
        accountMeta.toString() +
        "\n" +
        "campaignData:" +
        campaignData.toString() +
        "\n" +
        "action:" +
        action.toString() +
        "\n" +
        "}";
  }
}
