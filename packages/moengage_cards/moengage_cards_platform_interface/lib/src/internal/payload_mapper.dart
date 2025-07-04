// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:moengage_flutter/moengage_flutter.dart'
    show AccessibilityData, keyAccountMeta, keyAppId, keyData;

import '../../moengage_cards_platform_interface.dart';
import '../model/enums/static_image_type.dart';

WidgetStyle? widgetStyleFromJson(
  Map<String, dynamic>? json,
  WidgetType widgetType,
) {
  if (json == null) {
    return null;
  }
  switch (widgetType) {
    case WidgetType.text:
      return TextStyle.fromJson(json);
    case WidgetType.button:
      return ButtonStyle.fromJson(json);
    case WidgetType.image:
      return ImageStyle.fromJson(json);
  }
}

Action actionStyleFromJson(Map<String, dynamic> json) {
  final ActionType actionType =
      ActionType.values.byName(json[keyActionType] as String);
  switch (actionType) {
    case ActionType.navigate:
      return NavigationAction.fromJson(json);
  }
}

List<String> deSerializeCardsCategories(String payload) {
  final List<String> categories = <String>[];
  final Map<String, dynamic> data =
      json.decode(payload)[keyData] as Map<String, dynamic>;
  final Iterable<dynamic> cardCategories =
      (data[keyCategories] ?? []) as Iterable<dynamic>;
  for (final data in cardCategories) {
    categories.add(data.toString());
  }
  return categories;
}

CardsInfo deSerializeCardsInfo(String payload) {
  final dataPayload = jsonDecode(payload)[keyData];
  return CardsInfo.fromJson(dataPayload as Map<String, dynamic>);
}

CardsData deSerializeCardsData(String payload) {
  final dataPayload = jsonDecode(payload)[keyData];
  return CardsData.fromJson(dataPayload as Map<String, dynamic>);
}

bool deSerializeIsAllCategoryEnabled(String payload) {
  final Map<String, dynamic> dataPayload =
      jsonDecode(payload)[keyData] as Map<String, dynamic>;
  return (dataPayload[keyIsAllCategoryEnabled] ?? false) as bool;
}

int deSerializeNewCardsCount(String payload) {
  final Map<String, dynamic> dataPayload =
      jsonDecode(payload)[keyData] as Map<String, dynamic>;
  return (dataPayload[keyNewCardsCount] ?? 0) as int;
}

int deSerializeUnClickedCardsCount(String payload) {
  final Map<String, dynamic> json = jsonDecode(payload) as Map<String, dynamic>;
  final Map<String, dynamic> dataPayload =
      json[keyData] as Map<String, dynamic>;
  return (dataPayload[keyUnClickedCardsCount] ?? 0) as int;
}

Map<String, dynamic> getCardClickPayload(
  Card card,
  int widgetId,
  String appId,
) {
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: {keyWidgetIdentifier: widgetId, keyCard: card.toJson()}
  };
}

Map<String, dynamic> getCardShownPayload(Card card, String appId) {
  return {
    keyAccountMeta: getAppIdPayload(appId),
    keyData: {keyCard: card.toJson()}
  };
}

Map<String, dynamic> getCardsForCategoryPayload(String category, String appId) {
  return {
    keyAccountMeta: getAppIdPayload(appId),
    keyData: {keyCategory: category}
  };
}

Map<String, dynamic> getDeleteCardsPayload(List<Card> cards, String appId) {
  return {
    keyAccountMeta: getAppIdPayload(appId),
    keyData: {keyCards: cards.map((Card e) => e.toJson()).toList()}
  };
}

SyncType syncTypeFromString(String? syncType) {
  switch (syncType) {
    case argumentPullToRefreshSync:
      return SyncType.pullToRefresh;
    case argumentInboxOpenSync:
      return SyncType.inboxOpen;
    case argumentAppOpenSync:
      return SyncType.appOpen;
    case argumentImmediateSync:
      return SyncType.immediate;
    default:
      throw UnimplementedError('Sync Type Not Supported');
  }
}

String syncTypeToString(SyncType syncType) {
  switch (syncType) {
    case SyncType.pullToRefresh:
      return argumentPullToRefreshSync;
    case SyncType.inboxOpen:
      return argumentInboxOpenSync;
    case SyncType.appOpen:
      return argumentAppOpenSync;
    case SyncType.immediate:
      return argumentImmediateSync;
  }
}

Map<String, dynamic> getAppIdPayload(String appId) => {keyAppId: appId};

/// Parses static image accessibility data from JSON.
Map<StaticImageType, AccessibilityData>? parseStaticImageAccessibilityData(dynamic accessibilityJson) {
  if (accessibilityJson != null && accessibilityJson is Map<String, dynamic>) {
  return accessibilityJson.map(
    (key, value) => MapEntry(
    StaticImageType.fromString(key),
    AccessibilityData.fromJson(value as Map<String, dynamic>),
    ),
  );
  }
  return null;
}

/// Serializes static image accessibility data to JSON.
Map<String, dynamic>? serializeStaticImageAccessibilityData(Map<StaticImageType, AccessibilityData>? accessibilityData) {
  if (accessibilityData != null) {
  return accessibilityData.map(
    (key, value) => MapEntry(
    key.toShortString(),
    value.toJson(),
    ),
  );
  }
  return null;
}

/// Helper method to parse a list of Card objects from JSON.
List<Card> parseCardsListFromJson(dynamic json) {
   final list = (json ?? []) as Iterable;
    return list
        .map((cardJson) => Card.fromJson(cardJson as Map<String, dynamic>))
        .toList();
}

/// Helper method to serialize a list of `Card` objects to JSON.
List<Map<String, dynamic>> serializeCardsToJson(List<Card> cards) {
  return cards.map((card) => card.toJson()).toList();
}
