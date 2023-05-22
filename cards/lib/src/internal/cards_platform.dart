import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_cards/src/internal/callback_cache.dart';
import 'package:moengage_cards/src/internal/cards_platform_interface.dart';
import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/internal/payload_mapper.dart';
import 'package:moengage_cards/src/model/cards_data.dart';
import 'package:moengage_cards/src/model/sync_data.dart';
import 'package:moengage_flutter/internal/logger.dart';
import '../model/card.dart' as moe;
import '../model/cards_info.dart';
import 'cards_instance_provider.dart';

/// Common Implementation of Cards Platform Interface
abstract class MoEngageCardsPlatform extends MoEngageCardsPlatformInterface {
  static const String _tag = "${moduleTag}CardsPlatformBase";

  MethodChannel methodChannel = const MethodChannel(cardsMethodChannel);

  MoEngageCardsPlatform() : super() {
    methodChannel.setMethodCallHandler(_handler);
  }

  Future<dynamic> _handler(MethodCall call) async {
    try {
      final arguments = call.arguments;
      if (arguments == null) {
        return;
      }
      final json = jsonDecode(arguments.toString());
      final accountMeta = accountMetaFromMap(json[keyAccountMeta]);
      if (call.method == methodPullToRefreshCardsSync) {
        SyncCompleteData data =
            SyncCompleteData.fromJson(json[keyData][keySyncCompleteData]);
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .pullToRefreshOpenSyncListener
            ?.call(data);
      } else if (call.method == methodAppOpenSyncListener) {
        final arguments = call.arguments;
        if (arguments == null) {
          return;
        }
        SyncCompleteData data =
            SyncCompleteData.fromJson(json[keyData][keySyncCompleteData]);
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .appOpenSyncListener
            ?.call(data);
      } else if (call.method == methodPullToRefreshCardsSync) {
        final arguments = call.arguments;
        if (arguments == null) {
          return;
        }
        SyncCompleteData data =
            SyncCompleteData.fromJson(json[keyData][keySyncCompleteData]);
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .inboxOpenSyncListener
            ?.call(data);
      }
    } catch (err, stackTrace) {
      Logger.e("$_tag Error: ${call.toString()} has an Exception:",
          error: err, stackTrace: stackTrace);
    }
  }

  @override
  void initialize(String appId) {
    methodChannel.invokeMethod(
        methodInitialize, json.encode(getAccountMeta(appId)));
  }

  @override
  void refreshCards(String appId, CardsSyncListener cardsSyncListener) {
    CardsInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .pullToRefreshOpenSyncListener = cardsSyncListener;
    methodChannel.invokeMethod(
        methodRefreshCards, json.encode(getAccountMeta(appId)));
  }

  @override
  void onCardsSectionLoaded(String appId, CardsSyncListener cardsSyncListener) {
    CardsInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inboxOpenSyncListener = cardsSyncListener;
    methodChannel.invokeMethod(
        methodOnCardSectionLoaded, jsonEncode(getAccountMeta(appId)));
  }

  @override
  void onCardsSectionUnLoaded(String appId) {
    methodChannel.invokeMethod(
        methodOnCardSectionUnLoaded, jsonEncode(getAccountMeta(appId)));
  }

  @override
  Future<List<String>> getCardsCategories(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodCardsCategories, jsonEncode(getAccountMeta(appId)));
    return deSerializeCardsCategories(result);
  }

  @override
  Future<CardsInfo> getCardsInfo(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodCardsInfo, jsonEncode(getAccountMeta(appId)));
    return deSerializeCardsInfo(result);
  }

  @override
  void cardClicked(moe.Card card, int widgetId, String appId) {
    methodChannel.invokeMethod(methodCardClicked,
        jsonEncode(getCardClickPayload(card, widgetId, appId)));
  }

  @override
  void cardDelivered(String appId) {
    methodChannel.invokeMethod(
        methodCardDelivered, jsonEncode(getAccountMeta(appId)));
  }

  @override
  void cardShown(moe.Card card, String appId) {
    methodChannel.invokeMethod(
        methodCardShown, jsonEncode(getCardShownPayload(card, appId)));
  }

  @override
  Future<CardsData> getCardsForCategory(String category, String appId) async {
    String result = await methodChannel.invokeMethod(methodCardsForCategory,
        jsonEncode(getCardsForCategoryPayload(category, appId)));
    return deSerializeCardsData(result);
  }

  @override
  void deleteCards(List<moe.Card> cards, String appId) async {
    methodChannel.invokeMethod(
        methodDeleteCards, jsonEncode(getDeleteCardsPayload(cards, appId)));
  }

  @override
  Future<bool> isAllCategoryEnabled(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodIsAllCategoryEnabled, jsonEncode(getAccountMeta(appId)));
    return deSerializeIsAllCategoryEnabled(result);
  }

  @override
  Future<int> getNewCardsCount(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodNewCardsCount, jsonEncode(getAccountMeta(appId)));
    return deSerializeNewCardsCount(result);
  }

  @override
  Future<int> getUnClickedCardsCount(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodUnClickedCardsCount, jsonEncode(getAccountMeta(appId)));
    return deSerializeUnClickedCardsCount(result);
  }

  @override
  void setAppOpenCardsSyncListener(
      CardsSyncListener cardsSyncListener, String appId) {
    CardsInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .appOpenSyncListener = cardsSyncListener;
  }
}
