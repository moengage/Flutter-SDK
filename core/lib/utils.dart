import 'dart:convert';

import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/push_token.dart';
import 'package:moengage_flutter/self_handled.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/inapp_custom_action.dart';
import 'package:moengage_flutter/navigation_action.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/moe_push_service.dart';

Map<String, dynamic> getEventPayload(
    String eventName, MoEProperties eventAttributes) {
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

Map<String, dynamic> getUpdateSdkStatePayload(bool shouldEnableSdk) {
  return {keyIsSdkEnabled: shouldEnableSdk};
}

Map<String, dynamic> getMap(String key, dynamic value) {
  return <String, dynamic>{key: value};
}

InAppCampaign? inAppCampaignFromJson(dynamic methodCallArgs) {
  try {
    Map<String, dynamic> inAppCampaignMap = json.decode(methodCallArgs);

    if (inAppCampaignMap == null || inAppCampaignMap.isEmpty) {
      throw Exception("error: inAppCampaignFromJson() : map is empty");
    }

    String campaignId = inAppCampaignMap[keyCampaignId];
    if (campaignId == null || campaignId.isEmpty) {
      throw Exception(
          "error: inAppCampaignFromJson : campaignId is null/empty.");
    }

    String campaignName = inAppCampaignMap[keyCampaignName];

    if (campaignName == null || campaignName.isEmpty) {
      throw Exception(
          "error: inAppCampaignFromJson : campaignName is null/empty.");
    }

    String platform = inAppCampaignMap[keyPlatform];

    if (platform == null || platform.isEmpty) {
      throw Exception(
          "error: inAppCampaignFromJson() : platform is null/empty.");
    }

    InAppCampaign inAppCampaign =
        InAppCampaign(campaignId, campaignName, platform);
    inAppCampaign.navigationAction =
        navigationActionFromCampaignMap(inAppCampaignMap);
    inAppCampaign.selfHandled = selfHandledFromCampaignMap(inAppCampaignMap);
    inAppCampaign.customAction = customActionFromCampaignMap(inAppCampaignMap);

    return inAppCampaign;
  } catch (e) {
    print("error: inAppCampaignFromJson():: $e");
  }
  return null;
}

SelfHandled? selfHandledFromCampaignMap(Map<String, dynamic> inAppCampaignMap) {
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

NavigationAction? navigationActionFromCampaignMap(
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

CustomAction? customActionFromCampaignMap(
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

PushCampaign? pushCampaignFromJson(dynamic methodCallArgs) {
  try {
    Map<String, dynamic> pushCampaignMap = json.decode(methodCallArgs);
    String platform = pushCampaignMap.containsKey(keyPlatform)
        ? pushCampaignMap[keyPlatform]
        : null;

    if (platform == null) {
      throw Exception("error: pushCampaignFromJson() : platform is null.");
    }

    bool isDefaultAction = pushCampaignMap.containsKey(keyIsDefaultAction)
        ? pushCampaignMap[keyIsDefaultAction]
        : false;

    Map<String, dynamic> clickedAction =
        pushCampaignMap.containsKey(keyClickedAction)
            ? pushCampaignMap[keyClickedAction]
            : new Map();

    Map<String, dynamic> payload = pushCampaignMap.containsKey(keyPayload)
        ? pushCampaignMap[keyPayload]
        : new Map();

    return PushCampaign(platform, isDefaultAction, clickedAction, payload);
  } catch (e) {
    print("error: pushCampaignFromJson():: $e");
  }

  return null;
}

PushToken? pushTokenFromJson(dynamic methodCallArgs) {
  try {
    Map<String, dynamic> pushTokenPayload = json.decode(methodCallArgs);
    return PushToken(
        pushTokenPayload[keyPlatform],
        pushTokenPayload[keyPushToken],
        MoEPushServiceExt.fromString(pushTokenPayload[keyPushService]));
  } catch (exception) {
    print("Error: pushTokenFromJson() : ${exception.toString()}");
  }
  return null;
}
