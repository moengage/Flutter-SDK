import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'data_provider/data_model_provider.dart';
import 'data_provider/data_provider.dart';

void main() {
  test('Test Card Model Parsing', () {
    expect(jsonDecode(singleCard), cardModel.toJson());
  });

  test('Test Cards Data Model Parsing', () {
    expect(jsonDecode(cardsData), cardsDataModel.toJson());
  });

  test('Test Cards Info Model Parsing', () {
    expect(jsonDecode(cardsInfoData), cardsInfoModel.toJson());
  });

  test('Test Sync Complete Data', () {
    expect(jsonDecode(syncCompleteData), syncCompleteDataModel.toJson());
  });
}
