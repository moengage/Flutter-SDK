import 'dart:convert';
import 'dart:io';
import 'package:moengage_inbox/constants.dart';
import 'package:moengage_inbox/inbox_message.dart';
import 'package:moengage_inbox/payload_transformer.dart';

Map<String, dynamic> getAccountMeta(String appId) {
  return {
    ACCOUNT_META: {APP_ID: appId}
  };
}

Map<String, dynamic> getImpressionPayload(
    InboxMessage inboxMessage, String appId) {
  dynamic inboxPayload = messageToMap(inboxMessage);
  if (Platform.isAndroid) {
    inboxPayload = json.encode(inboxPayload);
  }
  return {
    ACCOUNT_META: {APP_ID: appId},
    DATA: inboxPayload
  };
}
