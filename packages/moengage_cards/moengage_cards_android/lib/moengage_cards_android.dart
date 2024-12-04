import 'dart:convert';

import 'package:moengage_cards_platform_interface/moengage_cards_platform_interface.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show Logger, getAccountMeta;

/// Android Implementation for Cards Platform Interface
class MoEngageCardsAndroid extends MoEngageCardsPlatform {
  /// Registers this class as the default instance of [MoEngageCardsPlatformInterface]
  static void registerWith() {
    Logger.v('Registering MoEngageCardsAndroid with Platform Interface');
    MoEngageCardsPlatformInterface.instance = MoEngageCardsAndroid();
  }

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
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeCardsData(result.toString());
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
    return deSerializeCardsCategories(result.toString());
  }

  @override
  Future<CardsInfo> getCardsInfo(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodCardsInfo,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeCardsInfo(result.toString());
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
    final dynamic result = await methodChannel.invokeMethod(
      methodCardsForCategory,
      jsonEncode(getCardsForCategoryPayload(category, appId)),
    );
    return deSerializeCardsData(result.toString());
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
    final dynamic result = await methodChannel.invokeMethod(
      methodIsAllCategoryEnabled,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeIsAllCategoryEnabled(result.toString());
  }

  @override
  Future<int> getNewCardsCount(String appId) async {
    final dynamic result = await methodChannel.invokeMethod(
      methodNewCardsCount,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeNewCardsCount(result.toString());
  }

  @override
  Future<int> getUnClickedCardsCount(String appId) async {
    final dynamic result = await methodChannel.invokeMethod(
      methodUnClickedCardsCount,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerializeUnClickedCardsCount(result.toString());
  }
}
