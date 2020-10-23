import 'dart:convert';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/self_handled.dart';

import 'constants.dart';
import 'inapp_custom_action.dart';
import 'navigation_action.dart';
import 'properties.dart';

Map<String, dynamic> getEventPayload(
    String eventName, MoEProperties eventAttributes) {
  if (eventAttributes == null) {
    eventAttributes = MoEProperties();
  }
  Map<String, dynamic> eventPayload = eventAttributes.getEventAttributeJson();
  eventPayload[keyEventName] = eventName;
  return eventPayload;
}

Map<String, dynamic> getUserAttributePayload(
    String attributeName, String attributeType, dynamic attributeValue) {
  if (attributeType == userAttrTypeLocation) {
    return <String, dynamic>{
      keyAttributeName: attributeName,
      keyAttributeType: attributeType,
      keyLocationAttribute: attributeValue
    };
  } else {
    return <String, dynamic>{
      keyAttributeName: attributeName,
      keyAttributeType: attributeType,
      keyAttributeValue: attributeValue
    };
  }
}

Map<String, dynamic> getOptOutTrackingPayload(
    String type, bool shouldOptOutDataTracking) {
  return {keyAttributeType: type, keyState: shouldOptOutDataTracking};
}

Map<String, dynamic> getMap(String key, dynamic value) {
  return <String, dynamic>{key: value};
}

InAppCampaign inAppCampaignFromMap(dynamic methodCallArgs) {
  try {
    Map<String, dynamic> inAppCampaignMap = json.decode(methodCallArgs);

    if (inAppCampaignMap == null || inAppCampaignMap.isEmpty) {
      throw Exception("error: inAppCampaignFromMap() : map is empty");
    }

    String campaignId = inAppCampaignMap[keyCampaignId];
    if (campaignId == null || campaignId.isEmpty) {
      throw Exception(
          "error: inAppCampaignFromMap : campaignId is null/empty.");
    }

    String campaignName = inAppCampaignMap[keyCampaignName];

    if (campaignName == null || campaignName.isEmpty) {
      throw Exception(
          "error: inAppCampaignFromMap : campaignName is null/empty.");
    }

    String platform = inAppCampaignMap[keyPlatform];

    if (platform == null || platform.isEmpty) {
      throw Exception(
          "error: inAppCampaignFromMap() : platform is null/empty.");
    }

    return InAppCampaign(
        campaignId,
        campaignName,
        platform,
        navigationActionFromCampaignMap(inAppCampaignMap),
        selfHandledFromCampaignMap(inAppCampaignMap),
        customActionFromCampaignMap(inAppCampaignMap));
  } catch (ex) {
    print("error: inAppCampaignFromMap : $ex");
  }
  return null;
}

SelfHandled selfHandledFromCampaignMap(Map<String, dynamic> inAppCampaignMap) {
  if (inAppCampaignMap.containsKey(keySelfHandled)) {
    Map<String, dynamic> selfHandledMap = inAppCampaignMap[keySelfHandled];

    return SelfHandled(
        selfHandledMap[keyPayload],
        selfHandledMap.containsKey(keyDismissInterval)
            ? selfHandledMap[keyDismissInterval]
            : -1,
        selfHandledMap.containsKey(keyIsCancellable)
            ? selfHandledMap[keyIsCancellable]
            : true);
  } else {
    return null;
  }
}

NavigationAction navigationActionFromCampaignMap(
    Map<String, dynamic> inAppCampaignMap) {
  if (inAppCampaignMap.containsKey(keyNavigation)) {
    Map<String, dynamic> navigationMap = inAppCampaignMap[keyNavigation];
    return NavigationAction(
        navigationMap[keyNavigationType],
        navigationMap[keyValue],
        navigationMap.containsKey(keyKvPair) ? navigationMap[keyKvPair] : null);
  } else {
    return null;
  }
}

CustomAction customActionFromCampaignMap(
    Map<String, dynamic> inAppCampaignMap) {
  if (inAppCampaignMap.containsKey(keyCustomAction)) {
    Map<String, dynamic> customActionMap = inAppCampaignMap[keyCustomAction];
    return customActionMap.containsKey(keyKvPair)
        ? CustomAction(customActionMap[keyKvPair])
        : null;
  } else {
    return null;
  }
}

PushCampaign pushCampaignFromMap(Map<String, dynamic> pushCampaignMap) {
  try {
    String platform = pushCampaignMap.containsKey(keyPlatform)
        ? pushCampaignMap[keyPlatform]
        : null;

    if (platform == null) {
      throw Exception("error: pushCampaignFromMap() : platform is null.");
    }

    bool isDefaultAction = pushCampaignMap.containsKey(keyIsDefaultAction)
        ? pushCampaignMap[keyIsDefaultAction]
        : false;

    Map<String, dynamic> clickedAction =
        pushCampaignMap.containsKey(keyClickedAction)
            ? pushCampaignMap[keyClickedAction]
            : null;

    Map<String, dynamic> payload = pushCampaignMap.containsKey(keyPayload)
        ? pushCampaignMap[keyPayload]
        : null;

    return PushCampaign(platform, isDefaultAction, clickedAction, payload);
  } catch (ex) {
    print("error: pushCampaignFromMap : $ex");
  }

  return null;
}
