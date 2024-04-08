import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';

import 'inbox_comparator.dart';
import 'src/data_provider_provider.dart';
import 'src/json_data_provider.dart';

void main() {
  test('Test Inbox Data', () {
    expect(
        InboxComparator().isInboxDataEqual(
            deSerializeInboxMessages(inboxPayload), inboxData),
        true);
  });

  test('Test Inbox Click Parser', () {
    expect(fetchUnclickedCount(inboxClickData), 1);
  });
}
