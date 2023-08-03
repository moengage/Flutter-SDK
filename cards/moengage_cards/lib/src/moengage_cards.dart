import 'package:moengage_cards_platform_interface/moengage_cards_platform_interface.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

/// Helper Class to interact with MoEngage Cards Feature
class MoEngageCards {
  MoEngageCards(this._appId);
  static const String _tag = '${moduleTag}MoEngageCards';

  /// Account identifier, APP ID on the MoEngage Dashboard.
  final String _appId;

  /// Cards Plugin Platform Interface
  final MoEngageCardsPlatformInterface _cardsPlatform =
      MoEngageCardsPlatformInterface.instance;

  /// Initialize the cards module
  void initialize() {
    Logger.v('$_tag initialize(): Initializing Cards Module');
    _cardsPlatform.initialize(_appId);
  }

  /// Ask the SDK to refresh cards on user request
  /// Note: This API is to be used to mimic the pull to refresh behaviour
  /// [cardsSyncListener] - Callback for Card Sync Completion of type [CardsSyncListener]
  void refreshCards(CardsSyncListener cardsSyncListener) {
    Logger.v('$_tag refreshCards(): Refresh Cards');
    _cardsPlatform.refreshCards(_appId, cardsSyncListener);
  }

  /// Fetch all Cards
  /// Note: This API refreshes cards data if inbox sync time interval expired
  Future<CardsData> fetchCards() {
    Logger.v('$_tag fetchCards(): Fetch Cards');
    return _cardsPlatform.fetchCards(_appId);
  }

  /// Notify the MoEngage SDK that card section has loaded
  /// Note: This API should be used when the cards/inbox screen is visible to user
  /// [cardsSyncListener] - Callback for Card Sync Completion of type [CardsSyncListener]
  Future<void> onCardsSectionLoaded(CardsSyncListener cardsSyncListener) async {
    Logger.v('$_tag onCardsSectionLoaded(): ');
    _cardsPlatform.onCardsSectionLoaded(_appId, cardsSyncListener);
  }

  /// Notifies the SDK that the inbox view is gone to the background
  /// Note: This API should be used when the cards screen is invisible to user
  void onCardsSectionUnLoaded() {
    Logger.v('$_tag onCardsSectionUnLoaded(): ');
    _cardsPlatform.onCardsSectionUnLoaded(_appId);
  }

  /// Returns a list of categories to be shown
  Future<List<String>> getCardsCategories() async {
    Logger.v('$_tag getCardsCategories(): Fetching list of Cards Categories');
    return _cardsPlatform.getCardsCategories(_appId);
  }

  /// Fetches all cards related data
  Future<CardsInfo> getCardsInfo() async {
    Logger.v('$_tag getCardsInfo(): Get Cards Related Info');
    return _cardsPlatform.getCardsInfo(_appId);
  }

  /// Marks a card as clicked and tracks an event for statistical purpose
  /// [card] - Instance of [Card]
  /// [widgetId] - Id of Widget , on which click action is performed
  void cardClicked(Card card, int widgetId) {
    Logger.v('$_tag cardClicked(): WidgetId - $widgetId');
    _cardsPlatform.cardClicked(card, widgetId, _appId);
  }

  /// Notify SDK that the card is delivered.
  /// Used for statistical purpose
  void cardDelivered() {
    _cardsPlatform.cardDelivered(_appId);
  }

  /// Notify SDK the card is shown to the user - Used for statistical purposes
  /// It is recommended to call this API in initState in Card Stateful Widget
  /// [card] - Instance of [Card]
  void cardShown(Card card) {
    _cardsPlatform.cardShown(card, _appId);
  }

  /// Fetch Cards for given [category]
  Future<CardsData> getCardsForCategory(String category) {
    return _cardsPlatform.getCardsForCategory(category, _appId);
  }

  /// Deletes the given card
  /// [card] - Instance of [Card]
  void deleteCard(Card card) {
    deleteCards([card]);
  }

  /// Deletes multiple cards at same time.
  /// [card] - List of [Card] object
  Future<void> deleteCards(List<Card> cards) async {
    await _cardsPlatform.deleteCards(cards, _appId);
  }

  /// Return true if  All cards category should be shown
  Future<bool> isAllCategoryEnabled() {
    return _cardsPlatform.isAllCategoryEnabled(_appId);
  }

  /// Return count of new cards available
  Future<int> getNewCardsCount() {
    return _cardsPlatform.getNewCardsCount(_appId);
  }

  /// Return count of UnClicked cards
  Future<int> getUnClickedCardsCount() async {
    return _cardsPlatform.getUnClickedCardsCount(_appId);
  }

  /// Listener for Cards App Open Sync Listener
  /// [cardsSyncListener] - Callback for Card Sync Completion of type [CardsSyncListener]
  void setAppOpenCardsSyncListener(CardsSyncListener cardsSyncListener) {
    _cardsPlatform.setAppOpenCardsSyncListener(cardsSyncListener, _appId);
  }
}
