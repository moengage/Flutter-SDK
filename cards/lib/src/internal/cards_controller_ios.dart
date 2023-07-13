import 'package:moengage_cards/src/internal/cards_platform.dart';
import 'package:moengage_cards/src/internal/payload_mapper.dart';
import '../../moengage_cards.dart';
import '../model/card.dart' as moe;
import 'package:moengage_cards/src/internal/constants.dart';

/// iOS specific implementation of Cards platform interface
class MoEiOSCardsController extends MoEngageCardsPlatform {
  MoEiOSCardsController() : super();

  @override
  void initialize(String appId) {
    methodChannel.invokeMethod(methodInitialize, getAccountMeta(appId));
  }

  @override
  void refreshCards(String appId, CardsSyncListener cardsSyncListener) {
    super.refreshCards(appId, cardsSyncListener);
    methodChannel.invokeMethod(methodRefreshCards, getAccountMeta(appId));
  }

  @override
  void onCardsSectionLoaded(String appId, CardsSyncListener cardsSyncListener) {
    super.onCardsSectionLoaded(appId, cardsSyncListener);
    methodChannel.invokeMethod(
        methodOnCardSectionLoaded, getAccountMeta(appId));
  }

  @override
  void setAppOpenCardsSyncListener(
      CardsSyncListener cardsSyncListener, String appId) {
    super.setAppOpenCardsSyncListener(cardsSyncListener, appId);
    methodChannel.invokeMethod(
        methodSetAppOpenCardsSyncListener, getAccountMeta(appId));
  }

  @override
  void onCardsSectionUnLoaded(String appId) {
    methodChannel.invokeMethod(
        methodOnCardSectionUnLoaded, getAccountMeta(appId));
  }

  @override
  Future<List<String>> getCardsCategories(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodCardsCategories, getAccountMeta(appId));
    return deSerializeCardsCategories(result);
  }

  @override
  Future<CardsInfo> getCardsInfo(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodCardsInfo, getAccountMeta(appId));
    return deSerializeCardsInfo(result);
  }

  @override
  void cardClicked(moe.Card card, int widgetId, String appId) {
    methodChannel.invokeMethod(
        methodCardClicked, getCardClickPayload(card, widgetId, appId));
  }

  @override
  void cardDelivered(String appId) {
    methodChannel.invokeMethod(methodCardDelivered, getAccountMeta(appId));
  }

  @override
  void cardShown(moe.Card card, String appId) {
    methodChannel.invokeMethod(
        methodCardShown, getCardShownPayload(card, appId));
  }

  @override
  Future<CardsData> getCardsForCategory(String category, String appId) async {
    String result = await methodChannel.invokeMethod(
        methodCardsForCategory, getCardsForCategoryPayload(category, appId));
    return deSerializeCardsData(result);
  }

  @override
  void deleteCards(List<moe.Card> cards, String appId) async {
    methodChannel.invokeMethod(
        methodDeleteCards, getDeleteCardsPayload(cards, appId));
  }

  @override
  Future<bool> isAllCategoryEnabled(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodIsAllCategoryEnabled, getAccountMeta(appId));
    return deSerializeIsAllCategoryEnabled(result);
  }

  @override
  Future<int> getNewCardsCount(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodNewCardsCount, getAccountMeta(appId));
    return deSerializeNewCardsCount(result);
  }

  @override
  Future<int> getUnClickedCardsCount(String appId) async {
    String result = await methodChannel.invokeMethod(
        methodUnClickedCardsCount, getAccountMeta(appId));
    return deSerializeUnClickedCardsCount(result);
  }
}
