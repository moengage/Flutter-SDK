import 'package:moengage_flutter/moengage_flutter.dart'
    show keyAccountMeta, keyAppId, keyData;
import '../model/inbox_message.dart';
import '../payload_transformer.dart';

/// Get Impression Payload [Map]
Map<String, dynamic> getImpressionPayload(
    InboxMessage inboxMessage, String appId) {
  final dynamic inboxPayload = messageToMap(inboxMessage);
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: inboxPayload
  };
}
