import 'dart:convert';

import 'package:moengage_cards/src/model/action.dart';
import 'package:moengage_cards/src/model/action_type.dart';
import 'package:moengage_cards/src/model/button_style.dart';
import 'package:moengage_cards/src/model/card.dart';
import 'package:moengage_cards/src/model/cards_info.dart';
import 'package:moengage_cards/src/model/cards_data.dart';
import 'package:moengage_cards/src/model/image_style.dart';
import 'package:moengage_cards/src/model/navigation_acion.dart';
import 'package:moengage_cards/src/model/sync_type.dart';
import 'package:moengage_cards/src/model/text_style.dart';
import 'package:moengage_cards/src/model/widget_style.dart';
import 'package:moengage_cards/src/model/widget_type.dart';
import 'package:moengage_flutter/model/account_meta.dart';

import 'constants.dart';

Map<String, dynamic> getAccountMeta(String appId) {
  return {
    keyAccountMeta: {keyAppId: appId}
  };
}

AccountMeta accountMetaFromMap(Map<String, dynamic> metaPayload) {
  return AccountMeta(metaPayload[keyAppId]);
}

WidgetStyle widgetStyleFromJson(
    Map<String, dynamic> json, WidgetType widgetType) {
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
  ActionType actionType = ActionType.values.byName(json[keyActionType]);
  switch (actionType) {
    case ActionType.navigate:
      return NavigationAction.fromJson(json);
  }
}

List<String> deSerializeCardsCategories(String payload) {
  List<String> categories = [];
  Map<String, dynamic> data = json.decode(payload);
  Map<String, dynamic> dataPayload = data[keyData];
  Iterable<dynamic> cardCategories =
      dataPayload[keyCategories] as Iterable<dynamic>;
  for (var data in cardCategories) {
    categories.add(data.toString());
  }
  return categories;
}

CardsInfo deSerializeCardsInfo(String payload) {
  Map<String, dynamic> json = jsonDecode(payload);
  Map<String, dynamic> dataPayload = json[keyData];
  return CardsInfo.fromJson(dataPayload);
}

CardsData deSerializeCardsData(String payload) {
  Map<String, dynamic> json = jsonDecode(payload);
  Map<String, dynamic> dataPayload = json[keyData];
  return CardsData.fromJson(dataPayload);
}

bool deSerializeIsAllCategoryEnabled(String payload) {
  Map<String, dynamic> json = jsonDecode(payload);
  Map<String, dynamic> dataPayload = json[keyData];
  return dataPayload[keyIsAllCategoryEnabled] ?? false;
}

int deSerializeNewCardsCount(String payload) {
  Map<String, dynamic> json = jsonDecode(payload);
  Map<String, dynamic> dataPayload = json[keyData];
  return dataPayload[keyNewCardsCount] ?? 0;
}

int deSerializeUnClickedCardsCount(String payload) {
  Map<String, dynamic> json = jsonDecode(payload);
  Map<String, dynamic> dataPayload = json[keyData];
  return dataPayload[keyUnClickedCardsCount] ?? 0;
}

Map<String, dynamic> getCardClickPayload(
    Card card, int widgetId, String appId) {
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: {keyWidgetIdentifier: widgetId, keyCard: card.toJson()}
  };
}

Map<String, dynamic> getCardShownPayload(Card card, String appId) {
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: {keyCard: card.toJson()}
  };
}

Map<String, dynamic> getCardsForCategoryPayload(String category, String appId) {
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: {keyCategory: category}
  };
}

Map<String, dynamic> getDeleteCardsPayload(List<Card> cards, String appId) {
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: {keyCards: cards.map((e) => e.toJson()).toList()}
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
      throw UnimplementedError("Sync Type Not Supported");
  }
}
