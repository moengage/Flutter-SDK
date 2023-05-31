import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards/moengage_cards.dart';
import 'cards_comparator.dart';
import 'data_provider/data_model_provider.dart';
import 'data_provider/data_provider.dart';

void main() {
  test('Test Card Model toJson Payload Mapper', () {
    expect(jsonDecode(singleCard), cardModel.toJson());
  });

  test('Test Cards Data Model fromJson Parsing', () {
    final actual = Card.fromJson(jsonDecode(singleCard));
    expect(CardsComparator().isCardEqual(actual, cardModel), true);
  });

  test('Test Cards Info Model toJson Payload Mapper', () {
    expect(jsonDecode(cardsInfoData), cardsInfoModel.toJson());
  });

  test('Test Card Model fromJson Parsing', () {
    final actual = CardsInfo.fromJson(jsonDecode(cardsInfoData));
    expect(CardsComparator().isCardInfoEqual(actual, cardsInfoModel), true);
  });

  test('Test Cards Data Model toJson Payload Mapper', () {
    expect(jsonDecode(cardsData), cardsDataModel.toJson());
  });

  test('Test Card Model From Json', () {
    final actual = CardsData.fromJson(jsonDecode(cardsData));
    expect(CardsComparator().isCardDataEquals(actual, cardsDataModel), true);
  });

  test('Test Sync Complete Data toJson Payload Mapper', () {
    expect(jsonDecode(syncCompleteData), syncCompleteDataModel.toJson());
  });

  test('Test Cards Info Model fromJson Parsing', () {
    final actual = SyncCompleteData.fromJson(jsonDecode(syncCompleteData));
    expect(CardsComparator().isSyncDataEquals(actual, syncCompleteDataModel),
        true);
  });
}
