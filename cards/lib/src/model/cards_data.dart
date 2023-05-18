import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/model/card.dart';

class CardsData {
  String category;
  List<Card> cards;

  CardsData({required this.category, required this.cards});

  factory CardsData.fromJson(Map<String, dynamic> json) => CardsData(
      category: json[keyCategory],
      cards: List.from(json[keyCards] as Iterable)
          .map((e) => Card.fromJson(e))
          .toList());
}
