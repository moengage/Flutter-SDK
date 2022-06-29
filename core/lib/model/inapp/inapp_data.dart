import 'package:moengage_flutter/model/account_meta.dart';
import 'package:moengage_flutter/model/inapp/campaign_data.dart';
import 'package:moengage_flutter/model/platforms.dart';

class InAppData {
  Platforms platform;
  AccountMeta accountMeta;
  CampaignData campaignData;

  InAppData(this.platform, this.accountMeta, this.campaignData);
}