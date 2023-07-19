import 'package:moengage_cards/src/internal/cards_platform.dart';
import 'package:moengage_cards/src/internal/payload_mapper.dart';
import '../../moengage_cards.dart';
import '../model/card.dart' as moe;
import 'dart:convert';
import 'package:moengage_cards/src/internal/constants.dart';

/// Android Implementation for Cards Platform Interface
class MoEAndroidCardsController extends MoEngageCardsPlatform {
  MoEAndroidCardsController() : super();

  @override
  void initialize(String appId) {
    methodChannel.invokeMethod(
        methodInitialize, jsonEncode(getAccountMeta(appId)));
  }

  @override
  void refreshCards(String appId, CardsSyncListener cardsSyncListener) {
    super.refreshCards(appId, cardsSyncListener);
    methodChannel.invokeMethod(
        methodRefreshCards, jsonEncode(getAccountMeta(appId)));
  }

  @override
  Future<CardsData> fetchCards(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodFetchCards, getAccountMeta(appId));
    return deSerializeCardsData(result);
  }

  @override
  void onCardsSectionLoaded(String appId, CardsSyncListener cardsSyncListener) {
    super.onCardsSectionLoaded(appId, cardsSyncListener);
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
}
