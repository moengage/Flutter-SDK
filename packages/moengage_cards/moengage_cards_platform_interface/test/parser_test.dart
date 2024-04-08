import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards_platform_interface/moengage_cards_platform_interface.dart';
import 'cards_comparator.dart';
import 'data_provider/data_model_provider.dart';
import 'data_provider/data_provider.dart';

void main() {
  test('Test Card Model toJson Payload Mapper', () {
    expect(jsonDecode(singleCard), cardModel.toJson());
  });

  test('Test Cards Data Model fromJson Parsing', () {
    final Card actual =
        Card.fromJson(jsonDecode(singleCard) as Map<String, dynamic>);
    expect(CardsComparator().isCardEqual(actual, cardModel), true);
  });

  test('Test Cards Info Model toJson Payload Mapper', () {
    expect(jsonDecode(cardsInfoData), cardsInfoModel.toJson());
  });

  test('Test Card Model fromJson Parsing', () {
    final CardsInfo actual =
        CardsInfo.fromJson(jsonDecode(cardsInfoData) as Map<String, dynamic>);
    expect(CardsComparator().isCardInfoEqual(actual, cardsInfoModel), true);
  });

  test('Test Cards Data Model toJson Payload Mapper', () {
    expect(jsonDecode(cardsData), cardsDataModel.toJson());
  });

  test('Test Card Model From Json', () {
    final CardsData actual =
        CardsData.fromJson(jsonDecode(cardsData) as Map<String, dynamic>);
    expect(CardsComparator().isCardDataEquals(actual, cardsDataModel), true);
  });

  test('Test Sync Complete Data toJson Payload Mapper', () {
    expect(jsonDecode(syncCompleteData), syncCompleteDataModel.toJson());
  });

  test('Test Cards Info Model fromJson Parsing', () {
    final SyncCompleteData actual = SyncCompleteData.fromJson(
      jsonDecode(syncCompleteData) as Map<String, dynamic>,
    );
    expect(
      CardsComparator().isSyncDataEquals(actual, syncCompleteDataModel),
      true,
    );
  });
}
