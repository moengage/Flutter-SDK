import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/self_handled.dart';

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
      keyAttributeType: userAttrTypeLocation,
      keyLocationAttribute: location.getLocationJson()
    };
  }

  InAppCampaign inAppCampaignFromMap(Map<String, dynamic> inAppCampaignMap) {
    String campaignId;
    String campaignName;
    String platform;
    NavigationAction navigationAction;
    SelfHandled selfHandled;
    CustomAction customAction;

    campaignId = inAppCampaignMap.containsKey(keyCampaignId)?
    inAppCampaignMap[keyCampaignId]: null;

    if (campaignId.isEmpty) {
      throw Exception("error: inAppCampaignFromMap : campaignId or campaignName is empty.");
    }

    campaignName = inAppCampaignMap.containsKey(keyCampaignName)?
    inAppCampaignMap[keyCampaignName]: null;

    if (campaignName.isEmpty) {
      throw Exception("error: inAppCampaignFromMap : campaignId or campaignName is empty.");
    }

    platform = inAppCampaignMap.containsKey(keyPlatform)?
    inAppCampaignMap[keyPlatform]: null;

    if (platform.isEmpty) {
      throw Exception("error: inAppCampaignFromMap() : platform is null.");
    }

    if (inAppCampaignMap.containsKey(keyNavigation)) {
      String navigationType;
      String url;
      Map<String, dynamic> keyValuePairs;

      Map<String, dynamic> navigationMap = inAppCampaignMap[keyNavigation];
      navigationType = navigationMap.containsKey(keyNavigationType)?
      navigationMap[keyNavigationType]: null;

      url = navigationMap.containsKey(keyValue)?
      navigationMap[keyValue]: null;

      keyValuePairs = navigationMap.containsKey(keyKvPair)?
      navigationMap[keyKvPair]: null;

      navigationAction = NavigationAction(navigationType, url, keyValuePairs);
    }
    if (inAppCampaignMap.containsKey(keySelfHandled)) {
      String campaignContent;
      int dismissInterval;
      bool cancellable;

      Map<String, dynamic> selfHandledMap = inAppCampaignMap[keySelfHandled];

      campaignContent = selfHandledMap.containsKey(keyPayload)?
      selfHandledMap[keyPayload]: null;

      cancellable = selfHandledMap.containsKey(keyDismissInterval)?
      selfHandledMap[keyDismissInterval]: null;

      campaignContent = selfHandledMap.containsKey(keyIsCancellable)?
      selfHandledMap[keyIsCancellable]: null;

      selfHandled = SelfHandled(campaignContent, dismissInterval, cancellable);
    }
    customAction = inAppCampaignMap.containsKey(keyCustomAction)?
    CustomAction(inAppCampaignMap[keyCustomAction]): null;

    return InAppCampaign(campaignId, campaignName, platform, navigationAction,
        selfHandled, customAction);
  }

  PushCampaign pushCampaignFromMap(Map<String, dynamic> pushCampaignMap) {
    String platform = pushCampaignMap.containsKey(keyPlatform)?
    pushCampaignMap[keyPlatform]: null;

    if (platform == null) {
      throw Exception("error: pushCampaignFromMap() : platform is null.");
    }

    bool isDefaultAction = pushCampaignMap.containsKey(keyIsDefaultAction)?
    pushCampaignMap[keyIsDefaultAction]: false;

    Map<String, dynamic> clickedAction = pushCampaignMap.containsKey(keyClickedAction)?
    pushCampaignMap[keyClickedAction]: null;

    Map<String, dynamic> payload = pushCampaignMap.containsKey(keyPayload)?
    pushCampaignMap[keyPayload]: null;

    return PushCampaign(platform, isDefaultAction, clickedAction, payload);
  }