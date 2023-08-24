import '../internal/constants.dart';
import 'card.dart';

/// Data for Cards for particular Category
class CardsData {
  /// [CardsData] Constructor
  CardsData({required this.category, required this.cards});

  /// Get [CardsData] from Json [Map]
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

  /// Convert [CardsData] to Json [Map]
  Map<String, dynamic> toJson() => {
        keyCategory: category,
        keyCards: cards.map((Card e) => e.toJson()).toList()
      };
}
