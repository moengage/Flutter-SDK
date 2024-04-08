import 'dart:convert';

import 'package:moengage_flutter/moengage_flutter.dart' show getAccountMeta;

import '../../moengage_cards_platform_interface.dart';

/// An implementation of [MoEngageCardsPlatform] that uses method channels.
class MethodChannelMoEngageCards extends MoEngageCardsPlatform {
  @override
  void initialize(String appId) {
    methodChannel.invokeMethod(
      methodInitialize,
      jsonEncode(getAccountMeta(appId)),
    );
  }

  @override
  void refreshCards(String appId, CardsSyncListener cardsSyncListener) {
    super.refreshCards(appId, cardsSyncListener);
    methodChannel.invokeMethod(
      methodRefreshCards,
      jsonEncode(getAccountMeta(appId)),
    );
  }

  @override
  Future<CardsData> fetchCards(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodFetchCards,
      getAccountMeta(appId),
    );
    return deSerializeCardsData(result as String);
  }

  @override
  void onCardsSectionLoaded(String appId, CardsSyncListener cardsSyncListener) {
    super.onCardsSectionLoaded(appId, cardsSyncListener);
    methodChannel.invokeMethod(
      methodOnCardSectionLoaded,
      jsonEncode(getAccountMeta(appId)),
    );
  }

  @override
  void onCardsSectionUnLoaded(String appId) {
    methodChannel.invokeMethod(
      methodOnCardSectionUnLoaded,
      jsonEncode(getAccountMeta(appId)),
    );
  }

  @override
  Future<List<String>> getCardsCategories(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodCardsCategories,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeCardsCategories(result as String);
  }

  @override
  Future<CardsInfo> getCardsInfo(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodCardsInfo,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeCardsInfo(result as String);
  }

  @override
  void cardClicked(Card card, int widgetId, String appId) {
    methodChannel.invokeMethod(
      methodCardClicked,
      jsonEncode(getCardClickPayload(card, widgetId, appId)),
    );
  }

  @override
  void cardDelivered(String appId) {
    methodChannel.invokeMethod(
      methodCardDelivered,
      jsonEncode(getAccountMeta(appId)),
    );
  }

  @override
  void cardShown(Card card, String appId) {
    methodChannel.invokeMethod(
      methodCardShown,
      jsonEncode(getCardShownPayload(card, appId)),
    );
  }

  @override
  Future<CardsData> getCardsForCategory(String category, String appId) async {
    final result = await methodChannel.invokeMethod(
      methodCardsForCategory,
      jsonEncode(getCardsForCategoryPayload(category, appId)),
    );
    return deSerializeCardsData(result as String);
  }

  @override
  Future<void> deleteCards(List<Card> cards, String appId) async {
    await methodChannel.invokeMethod(
      methodDeleteCards,
      jsonEncode(getDeleteCardsPayload(cards, appId)),
    );
  }

  @override
  Future<bool> isAllCategoryEnabled(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodIsAllCategoryEnabled,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeIsAllCategoryEnabled(result as String);
  }

  @override
  Future<int> getNewCardsCount(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodNewCardsCount,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeNewCardsCount(result as String);
  }

  @override
  Future<int> getUnClickedCardsCount(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodUnClickedCardsCount,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeUnClickedCardsCount(result as String);
  }
}
