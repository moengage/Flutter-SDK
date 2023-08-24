import '../model/inbox_message.dart';
import '../payload_transformer.dart';
import 'constants.dart';

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
