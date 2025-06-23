import 'package:moengage_flutter/moengage_flutter.dart' show AccessibilityData, keyAccessibility;
import '../internal/constants.dart';
import './enums/static_image_type.dart';
import 'card.dart';

/// Data for Cards for particular Category
class CardsData {
  /// [CardsData] Constructor
  CardsData({
  required this.category,
  required this.cards,
  this.staticImagesAccessibilityData,
  });

  /// Get [CardsData] from Json [Map]
  factory CardsData.fromJson(Map<String, dynamic> json) => CardsData(
    category: (json[keyCategory] ?? argumentAllCards) as String,
    cards: List.from((json[keyCards] ?? []) as Iterable)
      .map((e) => Card.fromJson(e as Map<String, dynamic>))
      .toList(),
    staticImagesAccessibilityData:
      (json[keyAccessibility] != null &&
          json[keyAccessibility] is Map<String, dynamic>)
        ? (json[keyAccessibility] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            StaticImageType.fromString(key),
            AccessibilityData.fromJson(
              value as Map<String, dynamic>),
          ),
          )
        : null,
    );

  /// Category in which Cards belong to
  String category;

  /// [List] of [Card] Model
  List<Card> cards;

  /// A map of static image accessibility data keyed by [StaticImageType].
  Map<StaticImageType, AccessibilityData>? staticImagesAccessibilityData;

  /// Convert [CardsData] to Json [Map]
  Map<String, dynamic> toJson() => {
    keyCategory: category,
    keyCards: cards.map((Card e) => e.toJson()).toList(),
    keyAccessibility: staticImagesAccessibilityData?.map(
      (key, value) => MapEntry(key.toShortString(), value.toJson()),
    ),
    };

  @override
  String toString() {
  return 'CardsData{category: $category, cards: $cards, staticImagesAccessibilityData: $staticImagesAccessibilityData}';
  }
}
