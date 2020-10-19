import 'package:moengage_flutter/inapp_custom_action.dart';
import 'package:moengage_flutter/inapp_navigation.dart';
import 'package:moengage_flutter/self_handled.dart';

import 'constants.dart';


class InAppCampaign {

  String campaignId;
  String campaignName;
  String platform;
  NavigationAction navigationAction;
  SelfHandled selfHandled;
  CustomAction customAction;

  InAppCampaign(this.campaignId, this.campaignName, this.platform,
      this.navigationAction, this.selfHandled,
      this.customAction);

  Map<String, dynamic> toJSON() {
    return {
      keyCampaignId: this.campaignId,
      keyCampaignName: this.campaignName,
      keyPlatform: this.platform,
      keyNavigation: this.navigationAction.toJSON(),
      keySelfHandled: this.selfHandled.toJSON(),
      keyCustomAction: this.customAction.toJSON()
    };
  }

  String toString() {
    return "{\n" +
        "campaignId:" + campaignId + "\n" +
        "campaignName:" + campaignName + "\n" +
        "platform:" + platform + "\n" +
        "navigationAction:" + navigationAction.toString() + "\n" +
        "selfHandled:" + selfHandled.toString() + "\n" +
        "customAction:" + customAction.toString() + "\n" +
        "}";
  }
}