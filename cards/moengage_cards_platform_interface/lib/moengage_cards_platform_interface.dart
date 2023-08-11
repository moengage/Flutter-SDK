import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moengage_cards_platform_interface.dart';
import 'src/method_channel_moengage_cards.dart';

export 'src/internal/cards_controller.dart';
export 'src/internal/cards_platform.dart';
export 'src/internal/constants.dart';
export 'src/internal/payload_mapper.dart';
export 'src/model/model.dart';

/// Card Sync Listener
typedef CardsSyncListener = void Function(SyncCompleteData? data);

/// Platform Interface for Cards Plugin
abstract class MoEngageCardsPlatformInterface extends PlatformInterface {
  /// Constructor for [MoEngageCardsPlatformInterface]
  MoEngageCardsPlatformInterface() : super(token: _token);

  /// Platform Specific Implementation of MoEngage Cards Plugin
  static MoEngageCardsPlatformInterface _instance =
      MethodChannelMoEngageCards();

  /// Token to validate Actual Implementation and Mock Implementation for test
  static final Object _token = Object();

  /// Instance of [MoEngageCardsPlatformInterface]
  static MoEngageCardsPlatformInterface get instance => _instance;

  /// Self Registration of Platform Interface used for tests and Platform specific packages
  static set instance(MoEngageCardsPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initialize the cards module
  void initialize(String appId) => throw UnimplementedError();

  /// Ask the SDK to refresh cards on user request
  /// Note: This API is to be used to mimic the pull to refresh behaviour
  /// [cardsSyncListener] - Callback for Card Sync Completion of type [CardsSyncListener]
  void refreshCards(String appId, CardsSyncListener cardsSyncListener) =>
      throw UnimplementedError();

  /// Fetch all Cards
  /// Note: This API refreshes cards data if inbox sync time interval expired
  Future<CardsData> fetchCards(String appId) async =>
      throw UnimplementedError();

  /// Notify the MoEngage SDK that card section has loaded
  /// Note: This API should be used when the cards/inbox screen is visible to user
  /// [cardsSyncListener] - Callback for Card Sync Completion of type [CardsSyncListener]
  void onCardsSectionLoaded(
          String appId, CardsSyncListener cardsSyncListener) =>
      throw UnimplementedError();

  /// Notifies the SDK that the inbox view is gone to the background
  /// Note: This API should be used when the cards screen is invisible to user
  void onCardsSectionUnLoaded(String appId) => throw UnimplementedError();

  /// Returns a list of categories to be shown
  Future<List<String>> getCardsCategories(String appId) async =>
      throw UnimplementedError();

  /// Fetches all cards related data
  Future<CardsInfo> getCardsInfo(String appId) async =>
      throw UnimplementedError();

  /// Marks a card as clicked and tracks an event for statistical purpose
  /// [card] - Instance of [Card]
  /// [widgetId] - Id of Widget , on which click action is performed
  void cardClicked(Card card, int widgetId, String appId) =>
      throw UnimplementedError();

  /// Notify SDK that the card is delivered.
  /// Used for statistical purpose
  void cardDelivered(String appId) => throw UnimplementedError();

  /// Notify SDK the card is shown to the user - Used for statistical purposes
  /// It is recommended to call this API in initState in Card Stateful Widget
  /// [card] - Instance of [Card]
  void cardShown(Card card, String appId) => throw UnimplementedError();

  /// Fetch Cards for given [category]
  Future<CardsData> getCardsForCategory(String category, String appId) =>
      throw UnimplementedError();

  /// Deletes multiple cards at same time.
  /// [card] - List of [Card] object
  Future<void> deleteCards(List<Card> cards, String appId) async =>
      throw UnimplementedError();

  /// Return true if  All cards category should be shown
  Future<bool> isAllCategoryEnabled(String appId) async =>
      throw UnimplementedError();

  /// Return count of new cards available
  Future<int> getNewCardsCount(String appId) async =>
      throw UnimplementedError();

  /// Return count of UnClicked cards
  Future<int> getUnClickedCardsCount(String appId) async =>
      throw UnimplementedError();

  /// Listener for Cards App Open Sync Listener
  /// [cardsSyncListener] - Callback for Card Sync Completion of type [CardsSyncListener]
  void setAppOpenCardsSyncListener(
    CardsSyncListener cardsSyncListener,
    String appId,
  ) =>
      throw UnimplementedError();
}
