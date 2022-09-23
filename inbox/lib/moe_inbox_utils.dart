import 'package:moengage_inbox/constants.dart';
import 'package:moengage_inbox/inbox_message.dart';
import 'package:moengage_inbox/payload_transformer.dart';

Map<String, dynamic> getAccountMeta(String appId) {
  return {
    keyAccountMeta: {keyAppId: appId}
  };
}

Map<String, dynamic> getImpressionPayload(
    InboxMessage inboxMessage, String appId) {
  dynamic inboxPayload = messageToMap(inboxMessage);
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: inboxPayload
  };
}
