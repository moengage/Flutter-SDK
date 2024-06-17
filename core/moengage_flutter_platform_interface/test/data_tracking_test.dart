import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

import 'data_provider/data_provider.dart';

void main() {
  test('Test Invalid MoEProperties', () {
    expect(dataWithInvalidProperties.generalAttributes, {
      'list': [
        'a',
        {'key': 'value'}
      ]
    });
    expect(dataWithInvalidProperties.locationAttributes, {
      'my_location': {'latitude': 1.2, 'longitude': 2.3}
    });
    expect(dataWithInvalidProperties.dateTimeAttributes,
        {'date': '2011-11-02T02:50:12.208Z'});
    expect(dataWithInvalidProperties.isNonInteractive, true);
  });
}
