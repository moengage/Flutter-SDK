import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/model/card.dart';

/// Data for Cards for particular Category
class CardsData {
  /// Category in which Cards belong to
  String category;

  /// [List] of [Card] Model
  List<Card> cards;

  CardsData({required this.category, required this.cards});

  factory CardsData.fromJson(Map<String, dynamic> json) => CardsData(
      category: json[keyCategory],
      cards: List.from((json[keyCards] ?? []) as Iterable)
          .map((e) => Card.fromJson(e))
          .toList());

  Map<String, dynamic> toJson() =>
      {keyCategory: category, keyCards: cards.map((e) => e.toJson()).toList()};
}
