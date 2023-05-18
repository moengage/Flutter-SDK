import '../internal/contants.dart';
import 'card.dart';

class CardsInfo {
  final bool isAllCategoryEnabled;
  final List<String> categories;
  final List<Card> cards;

  CardsInfo(
      {required this.isAllCategoryEnabled,
      required this.categories,
      required this.cards});

  factory CardsInfo.fromJson(Map<String, dynamic> json) {
    return CardsInfo(
        isAllCategoryEnabled: json[keyShouldShowAllTab] ?? false,
        categories: List.from(json[keyCategories] as Iterable)
            .map((e) => e.toString())
            .toList(),
        cards: List.from(json[keyCards] as Iterable)
            .map((e) => Card.fromJson(e))
            .toList());
  }

  Map<String,dynamic> toJson() => {
    keyShouldShowAllTab: isAllCategoryEnabled,
    keyCategories: categories,
    keyCards: cards.map((e)=>e.toJson())
  };
}
