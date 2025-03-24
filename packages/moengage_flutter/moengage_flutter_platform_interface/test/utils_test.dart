import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

void main() {
  test('Test Supported Identity with type String', () {
    expect(isSupportedIdentity('identity'), true);
  });

  test('Test Supported Identity with type Map<String, String>', () {
    expect(isSupportedIdentity({'id1': 'value1'}), true);
  });

  test('Test Supported Identity with type Map<String, dynamic>', () {
    expect(isSupportedIdentity({'id1': 'value1', 'id2': 2}), true);
  });

  test('Test Supported Identity with type Map<String, dynamic?>', () {
    expect(isSupportedIdentity({'id1': 'value1', 'id2': null}), true);
  });

  test('Test Supported Identity with type Map<String, Number>', () {
    expect(isSupportedIdentity({'id1': 2}), true);
  });

  test('Test Supported Identity with type Map<Number, String>', () {
    expect(isSupportedIdentity({2: 'string'}), false);
  });

  test('Test Supported Identity with type Number', () {
    expect(isSupportedIdentity(2), false);
  });
}
