import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/self_handled.dart';
import 'package:moengage_flutter/user_attribute_type.dart';

import 'constants.dart';
import 'geo_location.dart';
import 'inapp_custom_action.dart';
import 'inapp_navigation.dart';
import 'properties.dart';

  Map<String, dynamic> getEventPayload(String eventName,
      MoEProperties eventAttributes) {
    if (eventAttributes == null) {
      eventAttributes = MoEProperties();
    }
    var attributes = eventAttributes.getEventAttributeJson();
    return {
      keyEventName: eventName,
      keyEventAttributes: attributes
    };
  }

  Map<String, dynamic> getLocationPayload(String userAttributeName,
      MoEGeoLocation location) {
    return {
      keyAttributeName: userAttributeName,
      keyAttributeType: moEAttributeTypeToString(MoEAttributeType.location),
      keyLocationAttribute: location.getLocationJson()
    };
  }

  InAppCampaign fromMap(Map<String, dynamic> inAppCampaignMap) {
    String campaignId;
    String campaignName;
    String platform;
    NavigationAction navigationAction;
    SelfHandled selfHandled;
    CustomAction customAction;

    if (inAppCampaignMap.containsKey(keyCampaignId) ) {
      campaignId = inAppCampaignMap[keyCampaignId];
    }
    if (inAppCampaignMap.containsKey(keyCampaignName)) {
     campaignName = inAppCampaignMap[keyCampaignName];
    }

    if (campaignId.isNotEmpty || campaignName.isNotEmpty) {
  // todo log and return
    }
    if (inAppCampaignMap.containsKey(keyPlatform)) {
     platform = inAppCampaignMap[keyPlatform];
    }
    if (inAppCampaignMap.containsKey(keyNavigation)) {
      navigationAction = NavigationAction((inAppCampaignMap[keyNavigation]));
    }
    if (inAppCampaignMap.containsKey(keySelfHandled)) {
     selfHandled = SelfHandled((inAppCampaignMap[keySelfHandled]));
    }
    if (inAppCampaignMap.containsKey(keyCustomAction)) {
      customAction = CustomAction((inAppCampaignMap[keyCustomAction]));
    }

  }