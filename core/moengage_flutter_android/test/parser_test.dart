import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_android/src/internal/utils/payload_mapper.dart';

import 'comparator.dart';
import 'dataprovider/data_provider.dart';
import 'dataprovider/json_data.dart';

void main() {
  test('Test User Deletion Payload', () {
    expect(
        Comparator().isUserDeletionDataEqual(
            PayloadMapper().deSerializeDeleteUserData(userDeletionJson, appId),
            userDeletionData),
        true);
  });
}
