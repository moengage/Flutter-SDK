import '../internal/contants.dart';
import 'card.dart';

/// All data for cards.
class CardsInfo {
  /// True is showing ALL tabs is enabled else false.
  final bool isAllCategoryEnabled;

  /// All configured categories for cards.
  final List<String> categories;

  /// All cards which are eligible for display currently.
  final List<Card> cards;

  CardsInfo(
      {required this.isAllCategoryEnabled,
      required this.categories,
      required this.cards});

  factory CardsInfo.fromJson(Map<String, dynamic> json) {
    return CardsInfo(
        isAllCategoryEnabled: json[keyShouldShowAllTab] ?? false,
        categories: List.from((json[keyCategories] ?? []) as Iterable)
            .map((e) => e.toString())
            .toList(),
        cards: List.from((json[keyCards] ?? []) as Iterable)
            .map((e) => Card.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        keyShouldShowAllTab: isAllCategoryEnabled,
        keyCategories: categories,
        keyCards: cards.map((e) => e.toJson())
      };
}
