import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_android/src/internal/utils/payload_mapper.dart';

import 'comparator.dart';
import 'dataprovider/data_provider.dart';
import 'dataprovider/json_data.dart';

void main() {
  test('Test Init Payload', () {
    expect(
        Comparator().isUserDeletionDataEqual(
            deSerializeDeleteUserData(userDeletionJson, appId),
            userDeletionData),
        true);
  });
}
