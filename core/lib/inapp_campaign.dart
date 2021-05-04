import 'package:moengage_flutter/inapp_custom_action.dart';
import 'package:moengage_flutter/self_handled.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/navigation_action.dart';

/// Object representation of InApp Callback payload.
class InAppCampaign {
  /// Unique identifier for each campaign.
  String campaignId;

  /// Campaign Name
  String campaignName;

  /// Native platform from which the callback was triggered.
  String platform;

  /// Instance of [NavigationAction]
  NavigationAction? navigationAction;

  /// Instance of [SelfHandled]
  SelfHandled? selfHandled;

  /// Instance of [CustomAction]
  CustomAction? customAction;

  InAppCampaign(this.campaignId, this.campaignName, this.platform);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> inAppMap = {
      keyCampaignId: campaignId,
      keyCampaignName: campaignName,
      keyPlatform: platform
    };

    if (navigationAction != null) {
      inAppMap[keyNavigation] = navigationAction?.toMap();
    }
    if (selfHandled != null) {
      inAppMap[keySelfHandled] = selfHandled?.toMap();
    }
    if (customAction != null) {
      inAppMap[keyCustomAction] = customAction?.toMap();
    }
    return inAppMap;
  }

  String toString() {
    return "{\n" +
        "campaignId:" +
        campaignId +
        "\n" +
        "campaignName:" +
        campaignName +
        "\n" +
        "platform:" +
        platform +
        "\n" +
        "navigationAction:" +
        navigationAction.toString() +
        "\n" +
        "selfHandled:" +
        selfHandled.toString() +
        "\n" +
        "customAction:" +
        customAction.toString() +
        "\n" +
        "}";
  }
}
