import 'dart:io';

import 'package:moengage_cards/src/internal/callback_cache.dart';
import 'package:moengage_cards/src/internal/cards_controller_android.dart';
import 'package:moengage_cards/src/internal/cards_controller_ios.dart';
import 'package:moengage_cards/src/model/card.dart';
import 'package:moengage_cards/src/model/cards_info.dart';
import 'package:moengage_cards/src/model/cards_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class MoEngageCardsPlatformInterface extends PlatformInterface {
  MoEngageCardsPlatformInterface() : super(token: _token);

  static MoEngageCardsPlatformInterface _instance = (Platform.isAndroid)
      ? MoEAndroidCardsController()
      : MoEiOSCardsController();

  static final Object _token = Object();

  static MoEngageCardsPlatformInterface get instance => _instance;

  static set instance(MoEngageCardsPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  void initialize(String appId) => throw UnimplementedError();

  void refreshCards(String appId) => throw UnimplementedError();

  void onCardsSectionLoaded(String appId) async => throw UnimplementedError();

  void onCardsSectionUnLoaded(String appId) => throw UnimplementedError();

  Future<List<String>> getCardsCategories(String appId) async =>
      throw UnimplementedError();

  Future<CardsInfo> getCardsInfo(String appId) async =>
      throw UnimplementedError();

  void cardClicked(Card card, int widgetId, String appId) =>
      throw UnimplementedError();

  void cardDelivered(String appId) => throw UnimplementedError();

  void cardShown(Card card, String appId) => throw UnimplementedError();

  Future<CardsData> getCardsForCategory(String category, String appId) =>
      throw UnimplementedError();

  void deleteCards(List<Card> cards, String appId) async =>
      throw UnimplementedError();

  Future<bool> isAllCategoryEnabled(String appId) async =>
      throw UnimplementedError();

  Future<int> getNewCardsCount(String appId) async =>
      throw UnimplementedError();

  Future<int> getUnClickedCardsCount(String appId) async =>
      throw UnimplementedError();

  void setAppOpenCardsSyncListener(
          CardsSyncListener cardsSyncListener, String appId) async =>
      throw UnimplementedError();

  void setPullToRefreshSyncListener(
          CardsSyncListener cardsSyncListener, String appId) async =>
      throw UnimplementedError();

  void setInboxOpenSyncListener(
          CardsSyncListener cardsSyncListener, String appId) async =>
      throw UnimplementedError();
}
