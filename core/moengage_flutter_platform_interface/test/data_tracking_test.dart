import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

import 'data_provider/data_provider.dart';

void main() {
  test('Test Supported primitive type', () {
    expect(isSupportedPrimitiveType(1), true);
    expect(isSupportedPrimitiveType(1.5), true);
    expect(isSupportedPrimitiveType('String Value'), true);
    expect(isSupportedPrimitiveType(true), true);
    expect(isSupportedPrimitiveType(['list']), false);
    expect(isSupportedPrimitiveType({'key': 'value'}), false);
    expect(
        isSupportedPrimitiveType(
          const HtmlEscapeMode(),
        ),
        false);
  });

  test('Test Filter Iterables with Supported Types', () {
    expect(filterIterableWithSupportedTypes(arrayWithValidData),
        arrayWithValidData);
    expect(filterIterableWithSupportedTypes(arrayWithInvalidAndValidData),
        arrayWithValidData);
    expect(filterIterableWithSupportedTypes(arrayWithOnlyInvalidData), []);
    expect(filterIterableWithSupportedTypes(arrayWithNullValues),
        arrayWithValidData);
  });

  test('Test Filter Map with Supported Types', () {
    expect(filterMapWithSupportedTypes(mapWithValidData), mapWithValidData);
    expect(filterMapWithSupportedTypes(mapWithInvalidAndValidData),
        mapWithValidData);
    expect(filterMapWithSupportedTypes(mapWithInvalidData), {});
  });

  test('Test MoEProperties with Filtering Data', () {
    expect(dataWithInvalidProperties.generalAttributes, {
      'list': [
        'a',
        {'key': 'value'}
      ],
      'map': {'valid_data': 'string'}
    });

    expect(dataWithInvalidProperties.locationAttributes, {
      'my_location': {'latitude': 1.2, 'longitude': 2.3}
    });

    expect(dataWithInvalidProperties.dateTimeAttributes,
        {'date': '2011-11-02T02:50:12.208Z'});
    expect(dataWithInvalidProperties.isNonInteractive, true);
  });
}
