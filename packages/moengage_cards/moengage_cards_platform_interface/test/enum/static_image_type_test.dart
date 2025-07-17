import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards_platform_interface/src/model/model.dart';

void main() {
  group('StaticImageType', () {
    test('fromString returns correct enum for valid strings', () {
      expect(
          StaticImageType.fromString('no_cards'), StaticImageType.emptyState);
      expect(
          StaticImageType.fromString('pinned_card'), StaticImageType.pinCard);
      expect(StaticImageType.fromString('place_holder'),
          StaticImageType.loadingPlaceHolder);
    });

    test('fromString throws ArgumentError for invalid string', () {
      expect(() => StaticImageType.fromString('invalid_value'),
          throwsArgumentError);
      expect(() => StaticImageType.fromString(''), throwsArgumentError);
    });

    test('toShortString returns correct string value', () {
      expect(StaticImageType.emptyState.toShortString(), 'no_cards');
      expect(StaticImageType.pinCard.toShortString(), 'pinned_card');
      expect(
          StaticImageType.loadingPlaceHolder.toShortString(), 'place_holder');
    });

    test('enum value property returns correct string', () {
      expect(StaticImageType.emptyState.value, 'no_cards');
      expect(StaticImageType.pinCard.value, 'pinned_card');
      expect(StaticImageType.loadingPlaceHolder.value, 'place_holder');
    });
  });
}
