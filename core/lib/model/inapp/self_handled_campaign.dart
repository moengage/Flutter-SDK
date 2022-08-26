import 'package:moengage_flutter/constants.dart';

class SelfHandledCampaign {
  /// Self handled campaign payload.
  String campaignContent;

  /// Interval after which in-app should be dismissed, unit - Seconds
  int dismissInterval;

  SelfHandledCampaign(this.campaignContent, this.dismissInterval);

  String toString() {
    return "{\n" +
        "campaignContent:" +
        campaignContent +
        "\n" +
        "dismissInterval:" +
        dismissInterval.toString() +
        "\n" +
        "}";
  }
}
