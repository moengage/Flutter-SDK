import 'dart:core';

import 'package:flutter/services.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/payload_transformer.dart';
import 'package:moengage_inbox/constants.dart';

class MoEiOSInbox {
  MethodChannel _channel;

  MoEiOSInbox(this._channel);

  Future<int> getUnClickedCount(Map<String, dynamic> payload) async {
    String unClickedCountPayload =
        await _channel.invokeMethod(METHOD_NAME_UN_CLICKED_COUNT, payload);
    return fetchUnclickedCount(unClickedCountPayload);
  }

  void trackMessageClicked(Map<String, dynamic> payload) {
    _channel.invokeMethod(METHOD_NAME_TRACK_CLICKED, payload);
  }

  void deleteMessage(Map<String, dynamic> payload) {
    _channel.invokeMethod(METHOD_NAME_DELETE_MESSAGE, payload);
  }

  Future<InboxData?> fetchAllMessages(Map<String, dynamic> payload) async {
    String serialisedMessages =
        await _channel.invokeMethod(METHOD_NAME_FETCH_MESSAGES, payload);
    return deSerializeInboxMessages(serialisedMessages);
  }
}
