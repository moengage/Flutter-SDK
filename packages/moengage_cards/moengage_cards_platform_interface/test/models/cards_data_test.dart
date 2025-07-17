import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards_platform_interface/src/model/model.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show AccessibilityData, keyAccessibility;

import '../data_provider/data_model_provider.dart';

const String keyCategory = 'category';
const String keyCards = 'cards';
const String argumentAllCards = 'ALL';

void main() {
  group('CardsData', () {
    test('fromJson creates correct CardsData object', () {
      final Map<String, dynamic> json = {
        // Explicit type for json
        keyCategory: 'promotions',
        keyCards:
            [], // This is a List<dynamic> currently. If it's always Card objects, make it List<Card>
        keyAccessibility: {
          'no_cards': {
            'text': 'Banner Image',
            'hint': 'Banner image for promotions',
          }
        }
      };

      // The cast `as Map<String, dynamic>` here suggests that the original `json` might be inferred as `Map<String, Object?>` or similar.
      // Explicitly declaring `json` as `Map<String, dynamic>` at its creation can help.
      final cardsData = CardsData.fromJson(json);

      expect(cardsData.category, 'promotions');
      expect(cardsData.staticImagesAccessibilityData, isNotNull);
      expect(
          cardsData.staticImagesAccessibilityData!
              .containsKey(StaticImageType.emptyState),
          isTrue);
      expect(
          cardsData
              .staticImagesAccessibilityData![StaticImageType.emptyState]!.text,
          'Banner Image');
      expect(
          cardsData
              .staticImagesAccessibilityData![StaticImageType.emptyState]!.hint,
          'Banner image for promotions');
    });

    test('fromJson handles missing accessibility key', () {
      final Map<String, dynamic> json = {
        // Explicit type for json
        keyCategory: 'promotions',
        keyCards: [],
        // keyAccessibility is intentionally missing
      };

      final cardsData = CardsData.fromJson(json);

      expect(cardsData.category, 'promotions');
      expect(cardsData.staticImagesAccessibilityData, isNull);
    });

    test('fromJson handles null accessibility data', () {
      final Map<String, dynamic> json = {
        // Explicit type for json
        keyCategory: 'promotions',
        keyCards: [],
        keyAccessibility: null,
      };

      final cardsData = CardsData.fromJson(json);

      expect(cardsData.category, 'promotions');
      expect(cardsData.cards, isEmpty);
      expect(cardsData.staticImagesAccessibilityData, isNull);
    });

    test('toJson returns correct map', () {
      final card =
          cardModel; // Assuming cardModel is a specific type, e.g., Card
      final accessibilityData = AccessibilityData('text', 'hint');
      final cardsData = CardsData(
        category: 'promotions',
        cards: [card], // If 'cards' in CardsData is List<Card>, this is fine.
        staticImagesAccessibilityData: {
          StaticImageType.emptyState: accessibilityData,
        },
      );

      final Map<String, dynamic> json =
          cardsData.toJson(); // Explicit type for json

      expect(json[keyCategory], 'promotions');
      // Here, json[keyCards] is a List<dynamic> because toJson() returns Map<String, dynamic>
      // The actual type of elements in json[keyCards] is Map<String, dynamic>
      expect(json[keyCards], isA<List<Map<String, dynamic>>>());
      expect((json[keyCards] as List<dynamic>)[0]['card_id'],
          '123457'); // Explicit cast for clarity
      expect((json[keyCards] as List<dynamic>)[0]['id'],
          210); // Explicit cast for clarity
      // Similarly for accessibility data, it's a Map<String, dynamic>
      expect(
          (json[keyAccessibility] as Map<String, dynamic>)['no_cards']['text'],
          'text');
      expect(
          (json[keyAccessibility] as Map<String, dynamic>)['no_cards']['hint'],
          'hint');
    });

    test('toJson omits accessibility data if null', () {
      final card = cardModel;
      final cardsData = CardsData(
        category: 'promotions',
        cards: [card],
      );

      final Map<String, dynamic> json = cardsData.toJson();

      expect(json[keyCategory], 'promotions');
      expect(json[keyCards], isA<List<Map<String, dynamic>>>());
      expect((json[keyCards] as List<dynamic>)[0]['card_id'], '123457');
      expect((json[keyCards] as List<dynamic>)[0]['id'], 210);
      expect(json[keyAccessibility], isNull);
    });

    test('fromJson handles unknown StaticImageType gracefully', () {
      final Map<String, dynamic> json = {
        keyCategory: 'Promotions',
        keyCards: [],
        keyAccessibility: {
          'pinned_card': {
            'label': 'Unknown',
            'hint': 'Unknown hint',
          }
        }
      };

      final cardsData = CardsData.fromJson(json);

      // This expectation is good, as it checks if the key is indeed a StaticImageType.
      // The internal implementation of fromJson in CardsData needs to handle the conversion from String to StaticImageType.
      expect(cardsData.staticImagesAccessibilityData!.keys.first,
          isA<StaticImageType>());
    });
  });
}
