import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

import 'data_provider/data_provider.dart';
import 'mock_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final MockMoEngageFlutterPlatform mock = MockMoEngageFlutterPlatform();
  MoEngageFlutterPlatform.instance = mock;

  tearDown(() => {mock.clear()});

  test('User Attributes set', () async {
    final platform = MoEngageFlutter('12345');
    for (final entry in setUserAttributesData.entries) {
      platform.setUserAttribute(entry.key, entry.value);
      expect(mock.setUserAttributeLastUserAttributeName, entry.key);
      expect(mock.setUserAttributeLastUserAttributeValue, entry.value);
    }
  });

  test('User Attributes not set', () async {
    final platform = MoEngageFlutter('12345');
    for (final entry in unsetUserAttributesData.entries) {
      platform.setUserAttribute(entry.key, entry.value);
      expect(mock.setUserAttributeLastUserAttributeName, null);
      expect(mock.setUserAttributeLastUserAttributeValue, null);
    }
  });
}
