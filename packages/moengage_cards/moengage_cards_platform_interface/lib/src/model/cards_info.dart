import 'package:moengage_flutter/moengage_flutter.dart'
  show AccessibilityData, keyAccessibility;
import '../internal/constants.dart';
import 'card.dart';
import 'enums/static_image_type.dart';

/// All data for cards.
class CardsInfo {
  /// [CardsInfo] Constructor
  CardsInfo({
  required this.shouldShowAllTab,
  required this.categories,
  required this.cards,
  this.staticImagesAccessibilityData,
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
  }

  /// True is showing ALL tabs is enabled else false.
  final bool shouldShowAllTab;

  /// All configured categories for cards.
  final List<String> categories;

  /// All cards which are eligible for display currently.
  final List<Card> cards;

  /// A map of static image accessibility data keyed by [StaticImageType]
  Map<StaticImageType, AccessibilityData>? staticImagesAccessibilityData;

  /// Convert [CardsInfo] to Json [Map]
  Map<String, dynamic> toJson() => {
    keyShouldShowAllTab: shouldShowAllTab,
    keyCategories: categories,
    keyCards: cards.map((Card e) => e.toJson()).toList(),
    keyAccessibility: staticImagesAccessibilityData?.map(
      (key, value) => MapEntry(key.toShortString(), value.toJson()),
    ),
    };

  @override
  String toString() {
  return 'CardsInfo{shouldShowAllTab: $shouldShowAllTab, categories: $categories, cards: $cards, staticImagesAccessibilityData: $staticImagesAccessibilityData}';
  }
}
