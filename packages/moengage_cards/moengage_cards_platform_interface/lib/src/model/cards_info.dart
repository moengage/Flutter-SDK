import '../internal/constants.dart';
import 'card.dart';

/// All data for cards.
class CardsInfo {
  /// [CardsInfo] Constructor
  CardsInfo({
    required this.shouldShowAllTab,
    required this.categories,
    required this.cards,
  });

  /// Get [CardsInfo] from Json [Map]
  factory CardsInfo.fromJson(Map<String, dynamic> json) {
    return CardsInfo(
      shouldShowAllTab: (json[keyShouldShowAllTab] ?? false) as bool,
      categories: List.from((json[keyCategories] ?? []) as Iterable)
          .map((e) => e.toString())
          .toList(),
      cards: List.from((json[keyCards] ?? []) as Iterable)
          .map((e) => Card.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// True is showing ALL tabs is enabled else false.
  final bool shouldShowAllTab;

  /// All configured categories for cards.
  final List<String> categories;

  /// All cards which are eligible for display currently.
  final List<Card> cards;

  /// Convert [CardsInfo] to Json [Map]
  Map<String, dynamic> toJson() => {
        keyShouldShowAllTab: shouldShowAllTab,
        keyCategories: categories,
        keyCards: cards.map((Card e) => e.toJson())
      };
}
