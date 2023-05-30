import 'dart:io';

import 'package:moengage_cards/moengage_cards.dart';
import 'package:moengage_cards/src/internal/cards_controller_android.dart';
import 'package:moengage_cards/src/internal/cards_controller_ios.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Platform Interface for Cards Plugin
abstract class MoEngageCardsPlatformInterface extends PlatformInterface {
  MoEngageCardsPlatformInterface() : super(token: _token);

  /// Platform Specific Implementation
  static MoEngageCardsPlatformInterface _instance = getCardsPlatform();

  /// Token to validate Actual Implementation and Mock Implementation for test
  static final Object _token = Object();

  static MoEngageCardsPlatformInterface get instance => _instance;

  /// Self Registration of Platform Interface used for tests and Platform specific packages
  static set instance(MoEngageCardsPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  void initialize(String appId) => throw UnimplementedError();

  void refreshCards(String appId, CardsSyncListener cardsSyncListener) =>
      throw UnimplementedError();

  void onCardsSectionLoaded(
          String appId, CardsSyncListener cardsSyncListener) async =>
      throw UnimplementedError();

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

  static MoEngageCardsPlatformInterface getCardsPlatform() {
    if (Platform.isAndroid) {
      return MoEAndroidCardsController();
    } else if (Platform.isIOS) {
      return MoEiOSCardsController();
    } else {
      throw UnsupportedError("Platform Not Supported");
    }
  }
}
