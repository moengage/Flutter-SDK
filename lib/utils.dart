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
      print("ERROR: InAppCampaign fromMap() : campaignId or campaignName is empty.");
    }
    if (inAppCampaignMap.containsKey(keyPlatform)) {
     platform = inAppCampaignMap[keyPlatform];
    }
    if (inAppCampaignMap.containsKey(keyNavigation)) {
      String navigationType;
      String url;
      Map<String, dynamic> keyValuePairs;

      Map<String, dynamic> navigationMap = inAppCampaignMap[keyNavigation];
      if (navigationMap.containsKey(keyNavigationType)) {
        navigationType = navigationMap[keyNavigationType];
      }
      if (navigationMap.containsKey(keyValue)) {
        url = navigationMap[keyValue];
      }
      if (navigationMap.containsKey(keyKvPair)) {
        keyValuePairs = navigationMap[keyKvPair];
      }
      navigationAction = NavigationAction(navigationType, url, keyValuePairs);
    }
    if (inAppCampaignMap.containsKey(keySelfHandled)) {
      String campaignContent;
      int dismissInterval;
      bool cancellable;

      Map<String, dynamic> selfHandledMap = inAppCampaignMap[keySelfHandled];

      if (selfHandledMap.containsKey(keyPayload)) {
        campaignContent = selfHandledMap[keyPayload];
      }
      if (selfHandledMap.containsKey(keyDismissInterval)) {
        cancellable = selfHandledMap[keyDismissInterval];
      }
      if (selfHandledMap.containsKey(keyIsCancellable)) {
        campaignContent = selfHandledMap[keyIsCancellable];
      }
      selfHandled = SelfHandled(campaignContent, dismissInterval, cancellable);
    }
    if (inAppCampaignMap.containsKey(keyCustomAction)) {
      customAction = CustomAction(inAppCampaignMap[keyCustomAction]);
    }

    return InAppCampaign(campaignId, campaignName, platform, navigationAction,
        selfHandled, customAction);
  }