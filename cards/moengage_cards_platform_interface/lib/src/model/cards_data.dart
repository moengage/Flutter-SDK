import '../internal/constants.dart';
import 'card.dart';

/// Data for Cards for particular Category
class CardsData {
  CardsData({required this.category, required this.cards});

  factory CardsData.fromJson(Map<String, dynamic> json) => CardsData(
        category: (json[keyCategory] ?? argumentAllCards) as String,
        cards: List.from((json[keyCards] ?? []) as Iterable)
            .map((e) => Card.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Category in which Cards belong to
  String category;

  /// [List] of [Card] Model
  List<Card> cards;

  Map<String, dynamic> toJson() => {
        keyCategory: category,
        keyCards: cards.map((Card e) => e.toJson()).toList()
      };
}
