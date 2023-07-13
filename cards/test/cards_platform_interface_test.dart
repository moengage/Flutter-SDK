import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_cards/src/internal/cards_platform_interface.dart';
import 'package:moengage_cards/src/internal/constants.dart';

import 'cards_mock_platform.dart';
import 'data_provider/data_model_provider.dart';
import 'data_provider/data_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MoEngageCardsPlatformInterface mock = MockCardsPlatform();
  MoEngageCardsPlatformInterface.instance = mock;
  const MethodChannel channel = MethodChannel(cardsMethodChannel);

  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, methodCallHandler);

  test('CardsInfo Test', () async {
    final cardsInfo = await mock.getCardsInfo("");
    expect(cardsInfo.categories, ["promotions"]);
    expect(cardsInfo.shouldShowAllTab, true);
    expect(cardsInfo.toJson(), cardsInfoModel.toJson());
  });

  test('Is All category Enabled Test', () async {
    final isAllCategoryEnabled = await mock.isAllCategoryEnabled("");
    expect(isAllCategoryEnabled, false);
  });

  test('Get Cards Categories', () async {
    final cardsCategories = await mock.getCardsCategories("");
    expect(cardsCategories, ["promotion", "announcement"]);
  });

  test('New Cards Count', () async {
    final newCardsCount = await mock.getNewCardsCount("");
    expect(newCardsCount, 10);
  });

  test('UnClicked Cards Count', () async {
    final unClickedCardsCount = await mock.getUnClickedCardsCount("");
    expect(unClickedCardsCount, 20);
  });

  test('Get Cards For Category', () async {
    final cardsForCategory = await mock.getCardsForCategory("promotions", "");
    expect(cardsForCategory.toJson(), cardsDataModel.toJson());
  });
}

Future<dynamic> methodCallHandler(MethodCall methodCall) async {
  String methodResult = "";
  switch (methodCall.method) {
    case methodCardsInfo:
      methodResult = cardsInfoJson;
      break;
    case methodIsAllCategoryEnabled:
      methodResult = isAllCategoryEnabledJson;
      break;
    case methodCardsCategories:
      methodResult = cardsCategoriesJson;
      break;
    case methodNewCardsCount:
      methodResult = newCardsCountJson;
      break;
    case methodUnClickedCardsCount:
      methodResult = unClickedCardsCountJson;
      break;
    case methodCardsForCategory:
      methodResult = cardsForCategoryJson;
      break;
  }
  return methodResult;
}
