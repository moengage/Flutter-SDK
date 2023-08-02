import 'dart:convert';

import 'package:moengage_flutter_platform_interface/src/model/account_meta.dart';

import '../../moengage_cards_platform_interface.dart';

Map<String, dynamic> getAccountMeta(String appId) {
  return {keyAccountMeta: getAppIdPayload(appId)};
}

AccountMeta accountMetaFromMap(Map<String, dynamic> metaPayload) {
  return AccountMeta(metaPayload[keyAppId] as String);
}

WidgetStyle? widgetStyleFromJson(
  Map<String, dynamic>? json,
  WidgetType widgetType,
) {
  if (json == null) return null;
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
    default:
      throw UnsupportedError('ActionType Not Supported');
  }
}

List<String> deSerializeCardsCategories(String payload) {
  final List<String> categories = <String>[];
  final Map<String, dynamic> data =
      json.decode(payload)[keyData] as Map<String, dynamic>;
  final Iterable cardCategories =
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
    default:
      return '';
  }
}

Map<String, dynamic> getAppIdPayload(String appId) => {keyAppId: appId};
