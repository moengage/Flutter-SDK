import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

import 'data_provider/data_provider.dart';

void main() {
  final Map<String, dynamic> payload = getAccountMeta(dummyAppId);

  test('Test payload for String Identity', () {
    payload[keyData] = {
      keyUserIdentity: {keyUniqueUserIdentity: 'id1'}
    };
    expect(getIdentifyUserPayload('id1', dummyAppId), payload);
  });

  test('Test payload for Map Identity', () {
    payload[keyData] = {
      keyUserIdentity: {'key1': 'id1'}
    };
    expect(getIdentifyUserPayload({'key1': 'id1'}, dummyAppId), payload);
  });

  test('Test payload for Map Identity With Number', () {
    payload[keyData] = {
      keyUserIdentity: {'key1': 'id1', 'key2': 2}
    };
    expect(getIdentifyUserPayload({'key1': 'id1', 'key2': 2}, dummyAppId), payload);
  });

  test('Test payload for Map Identity With Null', () {
    payload[keyData] = {
      keyUserIdentity: {'key1': 'id1', 'key2': null}
    };
    expect(getIdentifyUserPayload({'key1': 'id1', 'key2': null}, dummyAppId), payload);
  });
}
