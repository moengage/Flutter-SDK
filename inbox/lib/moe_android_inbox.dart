import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/inbox_message.dart';
import 'package:moengage_inbox/payload_transformer.dart';

import 'constants.dart';

class MoEAndroidInbox {
  MethodChannel _channel;

  MoEAndroidInbox(this._channel);

  Future<int> getUnClickedCount() async {
    int count = await _channel.invokeMethod(METHOD_NAME_UN_CLICKED_COUNT);
    return count;
  }

  void trackMessageClicked(InboxMessage message) {
    _channel.invokeMethod(METHOD_NAME_TRACK_CLICKED, _getInboxPayload(message));
  }

  void deleteMessage(InboxMessage message) {
    _channel.invokeMethod(
        METHOD_NAME_DELETE_MESSAGE, _getInboxPayload(message));
  }

  Future<InboxData> fetchAllMessages() async {
    String serialisedMessages =
        await _channel.invokeMethod(METHOD_NAME_FETCH_MESSAGES);
    return deSerializeInboxMessages(serialisedMessages);
  }

  String _getInboxPayload(InboxMessage message) {
    return json.encode(messageToMap(message));
  }
}
