import '../../moengage_inbox_platform_interface.dart';

/// Get Account Meta [Map]
Map<String, dynamic> getAccountMeta(String appId) {
  return {
    keyAccountMeta: {keyAppId: appId}
  };
}

/// Get Impression Payload [Map]
Map<String, dynamic> getImpressionPayload(
    InboxMessage inboxMessage, String appId) {
  final dynamic inboxPayload = messageToMap(inboxMessage);
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: inboxPayload
  };
}
