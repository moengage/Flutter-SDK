

import 'package:moengage_flutter/self_handled.dart';

import 'constants.dart';
import 'inapp_custom_action.dart';
import 'inapp_navigation.dart';

class InAppCampaign {

  String campaignId;
  String campaignName;
  String platform;
  NavigationAction navigationAction;
  SelfHandled selfHandled;
  CustomAction customAction;

  InAppCampaign( String campaignId, String campaignName, String platform,
      NavigationAction navigationAction, SelfHandled selfHandled,
      CustomAction customAction) {
    this.campaignId = campaignId;
    this.campaignName = campaignName;
    this.platform = platform;
    this.navigationAction = navigationAction;
    this.selfHandled = selfHandled;
    this.customAction = customAction;
  }

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
}