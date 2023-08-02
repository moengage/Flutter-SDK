import '../../moengage_inbox_platform_interface.dart';

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
