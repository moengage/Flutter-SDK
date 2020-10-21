import 'dart:convert';
import 'package:moengage_flutter/inapp_campaign.dart';
import 'package:moengage_flutter/push_campaign.dart';
import 'package:moengage_flutter/self_handled.dart';

import 'constants.dart';
import 'inapp_custom_action.dart';
import 'inapp_navigation.dart';
import 'properties.dart';

  Map<String, dynamic> getEventPayload(String eventName,
      MoEProperties eventAttributes) {
    if (eventAttributes == null) {
      eventAttributes = MoEProperties();
    }
    Map<String, dynamic> eventPayload = eventAttributes.getEventAttributeJson();
    eventPayload[keyEventName] = eventName;
    return eventPayload;
  }

  String getEventPayloadJSON(String eventName,
    MoEProperties eventAttributes) {
    return json.encode(getEventPayload(eventName, eventAttributes));
  }

  Map<String, dynamic> getUserAttributePayload(String attributeName,
      String attributeType, dynamic attributeValue) {
    if (attributeType == userAttrTypeLocation) {
      return <String, dynamic>{
        keyAttributeName: attributeName,
        keyAttributeType: attributeType,
        keyLocationAttribute: attributeValue
      };
    }
    else {
      return <String, dynamic>{
        keyAttributeName: attributeName,
        keyAttributeType: attributeType,
        keyAttributeValue: attributeValue
      };
    }
  }

  String getUserAttributePayloadJSON(String attributeName,
    String attributeType, dynamic attributeValue) {
    return json.encode(getUserAttributePayload(attributeName,
        attributeType, attributeValue));
  }

  Map<String, dynamic> getOptOutTrackingPayload(String type,
      bool shouldOptOutDataTracking) {
    return {
      keyAttributeType: type,
      keyState: shouldOptOutDataTracking
    };
  }

  String getOptOutTrackingPayloadJSON(String type,
    bool shouldOptOutDataTracking) {
    return json.encode(
      getOptOutTrackingPayload(type, shouldOptOutDataTracking));
  }

  Map<String, String> getMap(String key, dynamic value) {
    return <String, String>{key: value} ;
  }

  InAppCampaign inAppCampaignFromMap(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> inAppCampaignMap = json.decode(methodCallArgs);

      if (inAppCampaignMap.isEmpty) {
        throw Exception("error: inAppCampaignFromMap() : map is empty");
      }

      String campaignId = inAppCampaignMap.containsKey(keyCampaignId) ?
      inAppCampaignMap[keyCampaignId] : null;

      if (campaignId.isEmpty) {
        throw Exception(
            "error: inAppCampaignFromMap : campaignId or campaignName is empty.");
      }

     String campaignName = inAppCampaignMap.containsKey(keyCampaignName) ?
      inAppCampaignMap[keyCampaignName] : null;

      if (campaignName.isEmpty) {
        throw Exception(
            "error: inAppCampaignFromMap : campaignId or campaignName is empty.");
      }

      String platform = inAppCampaignMap.containsKey(keyPlatform) ?
      inAppCampaignMap[keyPlatform] : null;

      if (platform.isEmpty) {
        throw Exception("error: inAppCampaignFromMap() : platform is empty.");
      }

      NavigationAction navigationAction;
      SelfHandled selfHandled;
      CustomAction customAction;

      if (inAppCampaignMap.containsKey(keyNavigation)) {
        String navigationType;
        String url;
        Map<String, dynamic> keyValuePairs;

        Map<String, dynamic> navigationMap = inAppCampaignMap[keyNavigation];
        navigationType = navigationMap.containsKey(keyNavigationType) ?
        navigationMap[keyNavigationType] : null;

        url = navigationMap.containsKey(keyValue) ?
        navigationMap[keyValue] : null;

        keyValuePairs = navigationMap.containsKey(keyKvPair) ?
        navigationMap[keyKvPair] : null;

        navigationAction = NavigationAction(navigationType, url, keyValuePairs);
      }
      if (inAppCampaignMap.containsKey(keySelfHandled)) {
        String campaignContent;
        int dismissInterval;
        bool cancellable;

        Map<String, dynamic> selfHandledMap = inAppCampaignMap[keySelfHandled];

        campaignContent = selfHandledMap.containsKey(keyPayload) ?
        selfHandledMap[keyPayload] : null;

        cancellable = selfHandledMap.containsKey(keyDismissInterval) ?
        selfHandledMap[keyDismissInterval] : null;

        campaignContent = selfHandledMap.containsKey(keyIsCancellable) ?
        selfHandledMap[keyIsCancellable] : null;

        selfHandled =
            SelfHandled(campaignContent, dismissInterval, cancellable);
      }
      customAction = inAppCampaignMap.containsKey(keyCustomAction) ?
      CustomAction(inAppCampaignMap[keyCustomAction]) : null;

      return InAppCampaign(campaignId, campaignName, platform, navigationAction,
          selfHandled, customAction);
    } catch (ex) {
      print("error: inAppCampaignFromMap : $ex");
    }
    return null;
  }

  PushCampaign pushCampaignFromMap(dynamic methodCallArgs) {
    try {
      Map<String, dynamic> pushCampaignMap = json.decode(
          methodCallArgs as String);
      String platform = pushCampaignMap.containsKey(keyPlatform) ?
      pushCampaignMap[keyPlatform] : null;

      if (platform == null) {
        throw Exception("error: pushCampaignFromMap() : platform is null.");
      }

      bool isDefaultAction = pushCampaignMap.containsKey(keyIsDefaultAction) ?
      pushCampaignMap[keyIsDefaultAction] : false;

      Map<String, dynamic> clickedAction = pushCampaignMap.containsKey(
          keyClickedAction) ?
      pushCampaignMap[keyClickedAction] : null;

      Map<String, dynamic> payload = pushCampaignMap.containsKey(keyPayload) ?
      pushCampaignMap[keyPayload] : null;

      return PushCampaign(platform, isDefaultAction, clickedAction, payload);
    } catch (ex) {
      print("error: pushCampaignFromMap : $ex");
    }

    return null;
  }