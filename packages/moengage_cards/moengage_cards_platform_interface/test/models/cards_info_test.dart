import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards_platform_interface/src/model/cards_info.dart';
import 'package:moengage_cards_platform_interface/src/model/enums/static_image_type.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

void main() {
  group('CardsInfo.fromJson', () {
    test('parses minimal json with required fields', () {
      final json = {
        'shouldShowAllTab': true,
        'categories': ['cat1', 'cat2'],
        'cards': [],
      };

      // Mock Card.fromJson if needed, or adjust according to your Card model
      expect(() => CardsInfo.fromJson(json), returnsNormally);
      final cardsInfo = CardsInfo.fromJson(json as Map<String, dynamic>);
      expect(cardsInfo.shouldShowAllTab, true);
      expect(cardsInfo.categories, ['cat1', 'cat2']);
      expect(cardsInfo.cards.length, 0);
    });

    test('parses with staticImagesAccessibilityData', () {
      final json = {
        'shouldShowAllTab': false,
        'categories': [],
        'cards': [],
        'accessibility': {
          'no_cards': {
            'text': 'icon label',
            'hint': 'icon hint',
          },
          'pinned_card': {
            'text': 'banner label',
            'hint': 'banner hint',
          }
        }
      };

      final cardsInfo = CardsInfo.fromJson(json);
      expect(cardsInfo.staticImagesAccessibilityData, isNotNull);
      expect(cardsInfo.staticImagesAccessibilityData!.length, 2);
      expect(cardsInfo.staticImagesAccessibilityData!.keys,
          contains(StaticImageType.emptyState));
      expect(cardsInfo.staticImagesAccessibilityData!.keys,
          contains(StaticImageType.pinCard));
      expect(cardsInfo.staticImagesAccessibilityData![StaticImageType.emptyState]!.text,
          'icon label');
    });

     test('parses with staticImagesAccessibilityData as null', () {
      final json = {
        'shouldShowAllTab': false,
        'categories': [],
        'cards': [],
        'accessibility': null
      };

      final cardsInfo = CardsInfo.fromJson(json);
      expect(cardsInfo.staticImagesAccessibilityData, isNull);
    });

    test('toJson returns correct map', () {
      final cardsInfo = CardsInfo(
        shouldShowAllTab: true,
        categories: ['cat1'],
        cards: [],
        staticImagesAccessibilityData: {
          StaticImageType.emptyState: AccessibilityData('label', 'hint')
        },
      );
      final map = cardsInfo.toJson();
      expect(map['shouldShowAllTab'], true);
      expect(map['categories'], ['cat1']);
      expect(map['cards'], isA<Iterable<Map<String,dynamic>>>());
      expect(map['accessibility'], isA<Map<String,dynamic>>());
      expect(map['accessibility']['no_cards'], {'text': 'label', 'hint': 'hint'});
    });


    test('toJson returns correct map', () {
      final cardsInfo = CardsInfo(
        shouldShowAllTab: true,
        categories: ['cat1'],
        cards: []
      );
      final map = cardsInfo.toJson();
      expect(map['shouldShowAllTab'], true);
      expect(map['categories'], ['cat1']);
      expect(map['cards'], isA<Iterable<Map<String,dynamic>>>());
      expect(map['accessibility'], isNull);
      });
  });
}
