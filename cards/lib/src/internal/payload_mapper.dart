import 'dart:convert';

import 'package:moengage_cards/src/model/action/action.dart';
import 'package:moengage_cards/src/model/enums/action_type.dart';
import 'package:moengage_cards/src/model/style/button_style.dart';
import 'package:moengage_cards/src/model/card.dart';
import 'package:moengage_cards/src/model/cards_info.dart';
import 'package:moengage_cards/src/model/cards_data.dart';
import 'package:moengage_cards/src/model/style/image_style.dart';
import 'package:moengage_cards/src/model/action/navigation_action.dart';
import 'package:moengage_cards/src/model/sync_type.dart';
import 'package:moengage_cards/src/model/style/text_style.dart';
import 'package:moengage_cards/src/model/style/widget_style.dart';
import 'package:moengage_cards/src/model/enums/widget_type.dart';
import 'package:moengage_flutter/model/account_meta.dart';

import '../model/action/custom_action.dart';
import 'constants.dart';

Map<String, dynamic> getAccountMeta(String appId) {
  return {keyAccountMeta: getAppIdPayload(appId)};
}

AccountMeta accountMetaFromMap(Map<String, dynamic> metaPayload) {
  return AccountMeta(metaPayload[keyAppId]);
}

WidgetStyle? widgetStyleFromJson(
    Map<String, dynamic>? json, WidgetType widgetType) {
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
  ActionType actionType = ActionType.values.byName(json[keyActionType]);
  switch (actionType) {
    case ActionType.navigate:
      return NavigationAction.fromJson(json);
    case ActionType.custom:
      return CustomAction.fromJson(json);
    default:
      throw UnsupportedError("ActionType Not Supported");
  }
}

List<String> deSerializeCardsCategories(String payload) {
  List<String> categories = [];
  Map<String, dynamic> data = json.decode(payload)[keyData];
  Iterable<dynamic> cardCategories =
      (data[keyCategories] ?? []) as Iterable<dynamic>;
  for (var data in cardCategories) {
    categories.add(data.toString());
  }
  return categories;
}

CardsInfo deSerializeCardsInfo(String payload) {
  Map<String, dynamic> dataPayload = jsonDecode(payload)[keyData];
  return CardsInfo.fromJson(dataPayload);
}

CardsData deSerializeCardsData(String payload) {
  Map<String, dynamic> dataPayload = jsonDecode(payload)[keyData];
  return CardsData.fromJson(dataPayload);
}

bool deSerializeIsAllCategoryEnabled(String payload) {
  Map<String, dynamic> dataPayload = jsonDecode(payload)[keyData];
  return dataPayload[keyIsAllCategoryEnabled] ?? false;
}

int deSerializeNewCardsCount(String payload) {
  Map<String, dynamic> dataPayload = jsonDecode(payload)[keyData];
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

String syncTypeToString(SyncType syncType) {
  switch (syncType) {
    case SyncType.pullToRefresh:
      return argumentPullToRefreshSync;
    case SyncType.inboxOpen:
      return argumentInboxOpenSync;
    case SyncType.appOpen:
      return argumentAppOpenSync;
    default:
      return "";
  }
}

Map<String, dynamic> getAppIdPayload(String appId) => {keyAppId: appId};
