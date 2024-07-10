import 'package:moengage_cards_platform_interface/moengage_cards_platform_interface.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show Logger, getAccountMeta;

/// iOS specific implementation of Cards platform interface
class MoEngageCardsIOS extends MoEngageCardsPlatform {
  /// Registers this class as the default instance of [MoEngageCardsPlatformInterface]
  static void registerWith() {
    Logger.v('Registering MoEngageCardsIOS with Platform Interface');
    MoEngageCardsPlatformInterface.instance = MoEngageCardsIOS();
  }

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
      getAccountMeta(appId),
    );
  }

  @override
  void setSyncCompleteListener(
    CardsSyncListener cardsSyncListener,
    String appId,
  ) {
    super.setSyncCompleteListener(cardsSyncListener, appId);
    methodChannel.invokeMethod(
      methodSetAppOpenCardsSyncListener,
      getAccountMeta(appId),
    );
  }

  @override
  void onCardsSectionUnLoaded(String appId) {
    methodChannel.invokeMethod(
      methodOnCardSectionUnLoaded,
      getAccountMeta(appId),
    );
  }

  @override
  Future<List<String>> getCardsCategories(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodCardsCategories,
      getAccountMeta(appId),
    );
    return deSerializeCardsCategories(result.toString());
  }

  @override
  Future<CardsInfo> getCardsInfo(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodCardsInfo,
      getAccountMeta(appId),
    );
    return deSerializeCardsInfo(result.toString());
  }

  @override
  void cardClicked(Card card, int widgetId, String appId) {
    methodChannel.invokeMethod(
      methodCardClicked,
      getCardClickPayload(card, widgetId, appId),
    );
  }

  @override
  void cardDelivered(String appId) {
    methodChannel.invokeMethod(methodCardDelivered, getAccountMeta(appId));
  }

  @override
  void cardShown(Card card, String appId) {
    methodChannel.invokeMethod(
      methodCardShown,
      getCardShownPayload(card, appId),
    );
  }

  @override
  Future<CardsData> getCardsForCategory(String category, String appId) async {
    final result = await methodChannel.invokeMethod(
      methodCardsForCategory,
      getCardsForCategoryPayload(category, appId),
    );
    return deSerializeCardsData(result.toString());
  }

  @override
  Future<void> deleteCards(List<Card> cards, String appId) async {
    await methodChannel.invokeMethod(
      methodDeleteCards,
      getDeleteCardsPayload(cards, appId),
    );
  }

  @override
  Future<bool> isAllCategoryEnabled(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodIsAllCategoryEnabled,
      getAccountMeta(appId),
    );
    return deSerializeIsAllCategoryEnabled(result.toString());
  }

  @override
  Future<int> getNewCardsCount(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodNewCardsCount,
      getAccountMeta(appId),
    );
    return deSerializeNewCardsCount(result.toString());
  }

  @override
  Future<int> getUnClickedCardsCount(String appId) async {
    final result = await methodChannel.invokeMethod(
      methodUnClickedCardsCount,
      getAccountMeta(appId),
    );
    return deSerializeUnClickedCardsCount(result.toString());
  }
}
