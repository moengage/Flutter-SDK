import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moengage_cards_platform_interface.dart';
import 'src/method_channel_moengage_cards.dart';

export 'src/internal/cards_platform.dart';
export 'src/internal/constants.dart';
export 'src/internal/cards_controller.dart';
export 'src/internal/payload_mapper.dart';
export 'src/model/model.dart';

typedef CardsSyncListener = void Function(SyncCompleteData? data);

/// Platform Interface for Cards Plugin
abstract class MoEngageCardsPlatformInterface extends PlatformInterface {
  MoEngageCardsPlatformInterface() : super(token: _token);

  /// Platform Specific Implementation of MoEngage Cards Plugin
  static MoEngageCardsPlatformInterface _instance =
      MethodChannelMoEngageCards();

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

  Future<CardsData> fetchCards(String appId) async =>
      throw UnimplementedError();

  void onCardsSectionLoaded(
          String appId, CardsSyncListener cardsSyncListener) =>
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

  Future<void> deleteCards(List<Card> cards, String appId) async =>
      throw UnimplementedError();

  Future<bool> isAllCategoryEnabled(String appId) async =>
      throw UnimplementedError();

  Future<int> getNewCardsCount(String appId) async =>
      throw UnimplementedError();

  Future<int> getUnClickedCardsCount(String appId) async =>
      throw UnimplementedError();

  void setAppOpenCardsSyncListener(
    CardsSyncListener cardsSyncListener,
    String appId,
  ) =>
      throw UnimplementedError();
}
