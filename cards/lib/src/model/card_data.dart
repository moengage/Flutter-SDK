import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/card.dart';

/// Data for all fetched Cards
class CardData {
  /// [List] of [Card] Model
  List<Card> cards;

  CardData({required this.cards});

  factory CardData.fromJson(Map<String, dynamic> json) => CardData(
      cards: List.from((json[keyCards] ?? []) as Iterable)
          .map((e) => Card.fromJson(e))
          .toList());

  Map<String, dynamic> toJson() =>
      {keyCards: cards.map((e) => e.toJson()).toList()};
}
