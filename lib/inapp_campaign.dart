import 'package:moengage_flutter/inapp_custom_action.dart';
import 'package:moengage_flutter/inapp_navigation.dart';
import 'package:moengage_flutter/self_handled.dart';

import 'constants.dart';
import 'constants.dart';
import 'constants.dart';
import 'constants.dart';
import 'constants.dart';
import 'constants.dart';
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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> inAppMap = Map<String, dynamic> ();
    inAppMap[keyCampaignId] = this.campaignId;
    inAppMap[keyCampaignName] = this.campaignName;
    inAppMap[keyPlatform] = this.platform;

    if (navigationAction != null) {
      inAppMap[keyNavigation] = navigationAction.toMap();
    }
    if (selfHandled != null) {
      inAppMap[keySelfHandled] = selfHandled.toMap();
    }
    if (customAction != null) {
      inAppMap[keyCustomAction] = customAction.toMap();
    }
     return inAppMap;
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