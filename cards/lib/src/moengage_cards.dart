import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moengage_cards/src/internal/callback_cache.dart';
import 'package:moengage_cards/src/internal/cards_platform_interface.dart';
import 'package:moengage_cards/src/model/card.dart';
import 'package:moengage_cards/src/model/cards_info.dart';
import 'package:moengage_cards/src/model/cards_data.dart';

import 'internal/contants.dart';

class MoEngageCards {
  final String appId;

  late MoEngageCardsPlatformInterface cardsPlatform;

  MoEngageCards(this.appId) {
    cardsPlatform = MoEngageCardsPlatformInterface.instance;
  }

  @visibleForTesting
  final methodChannel = const MethodChannel(cardsMethodChannel);

  void initialize() {
    cardsPlatform.initialize(appId);
  }

  void refreshCards() {
    cardsPlatform.refreshCards(appId);
  }

  void onCardsSectionLoaded() async {
    cardsPlatform.onCardsSectionLoaded(appId);
  }

  void onCardsSectionUnLoaded() {
    cardsPlatform.onCardsSectionUnLoaded(appId);
  }

  Future<List<String>> getCardsCategories() async {
    return cardsPlatform.getCardsCategories(appId);
  }

  Future<CardsInfo> getCardsInfo() async {
    return cardsPlatform.getCardsInfo(appId);
  }

  void cardClicked(Card card, int widgetId) {
    cardsPlatform.cardClicked(card, widgetId, appId);
  }

  void cardDelivered() {
    cardsPlatform.cardDelivered(appId);
  }

  void cardShown(Card card) {
    cardsPlatform.cardShown(card, appId);
  }

  Future<CardsData> getCardsForCategory(String category) {
    return cardsPlatform.getCardsForCategory(category, appId);
  }

  void deleteCard(Card card) {
    deleteCards([card]);
  }

  void deleteCards(List<Card> cards) async {
    cardsPlatform.deleteCards(cards, appId);
  }

  Future<bool> isAllCategoryEnabled() {
    return cardsPlatform.isAllCategoryEnabled(appId);
  }

  Future<int> getNewCardsCount() {
    return cardsPlatform.getNewCardsCount(appId);
  }

  Future<int> getUnClickedCardsCount() async {
    return cardsPlatform.getUnClickedCardsCount(appId);
  }

  void setAppOpenCardsSyncListener(
      CardsSyncListener cardsSyncListener, String appId) {
    cardsPlatform.setAppOpenCardsSyncListener(cardsSyncListener, appId);
  }

  void setPullToRefreshSyncListener(CardsSyncListener cardsSyncListener) {
    cardsPlatform.setPullToRefreshSyncListener(cardsSyncListener, appId);
  }

  void setInboxOpenSyncListener(CardsSyncListener cardsSyncListener) {
    cardsPlatform.setPullToRefreshSyncListener(cardsSyncListener, appId);
  }
}
