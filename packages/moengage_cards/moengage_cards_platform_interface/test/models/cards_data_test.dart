import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards_platform_interface/src/model/cards_data.dart';
import 'package:moengage_cards_platform_interface/src/model/enums/static_image_type.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show AccessibilityData, keyAccessibility;

import '../data_provider/data_model_provider.dart';

const String keyCategory = 'category';
const String keyCards = 'cards';
const String argumentAllCards = 'ALL';

void main() {
  group('CardsData', () {
    test('fromJson creates correct CardsData object', () {
      final json = {
        keyCategory: 'promotions',
        keyCards: [],
        keyAccessibility: {
          'no_cards': {
            'text': 'Banner Image',
            'hint': 'Banner image for promotions',
          }
        }
      };

      final cardsData = CardsData.fromJson(json as Map<String, dynamic>);

      expect(cardsData.category, 'promotions');
      expect(cardsData.staticImagesAccessibilityData, isNotNull);
      expect(cardsData.staticImagesAccessibilityData!.containsKey(StaticImageType.emptyState), isTrue);
      expect(cardsData.staticImagesAccessibilityData![StaticImageType.emptyState]!.text, 'Banner Image');
      expect(cardsData.staticImagesAccessibilityData![StaticImageType.emptyState]!.hint, 'Banner image for promotions');
    });

    test('fromJson handles missing accessibility key', () {
      final json = {
        keyCategory: 'promotions',
        keyCards: [],
        // keyAccessibility is intentionally missing
      };

      final cardsData = CardsData.fromJson(json);

      expect(cardsData.category, 'promotions');
      expect(cardsData.staticImagesAccessibilityData, isNull);
    });

    test('fromJson handles null accessibility data', () {
      final json = {
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
      final card = cardModel;
      final accessibilityData = AccessibilityData('text', 'hint');
      final cardsData = CardsData(
        category: 'promotions',
        cards: [card],
        staticImagesAccessibilityData: {
          StaticImageType.emptyState: accessibilityData,
        },
      );

      final json = cardsData.toJson();

      expect(json[keyCategory], 'promotions');
      expect(json[keyCards], isA<List>());
      expect(json[keyCards][0]['card_id'], '123457');
      expect(json[keyCards][0]['id'], 210);
      expect(json[keyAccessibility]['no_cards']['text'], 'text');
      expect(json[keyAccessibility]['no_cards']['hint'], 'hint');
    });

    test('toJson omits accessibility data if null', () {
      final card = cardModel;
      final cardsData = CardsData(
        category: 'promotions',
        cards: [card],
      );

      final json = cardsData.toJson();

      expect(json[keyCategory], 'promotions');
      expect(json[keyCards], isA<List>());
      expect(json[keyCards][0]['card_id'], '123457');
      expect(json[keyCards][0]['id'], 210);
      expect(json[keyAccessibility], isNull);
    });

    test('fromJson handles unknown StaticImageType gracefully', () {
      final json = {
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

      expect(cardsData.staticImagesAccessibilityData!.keys.first, isA<StaticImageType>());
    });
  });
}
