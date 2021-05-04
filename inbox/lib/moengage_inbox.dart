import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moengage_inbox/constants.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/inbox_message.dart';
import 'package:moengage_inbox/moe_android_inbox.dart';
import 'package:moengage_inbox/moe_ios_inbox.dart';

class MoEngageInbox {
  late MethodChannel _channel;
  late MoEAndroidInbox _androidInbox;
  late MoEiOSInbox _iOSInbox;

  MoEngageInbox() {
    _channel = MethodChannel(CHANNEL_NAME);
    _androidInbox = MoEAndroidInbox(_channel);
    _iOSInbox = MoEiOSInbox(_channel);
  }

  void trackMessageClicked(InboxMessage message) {
    if (Platform.isAndroid) {
      _androidInbox.trackMessageClicked(message);
    } else if (Platform.isIOS) {
      _iOSInbox.trackMessageClicked(message);
    }
  }

  void deleteMessage(InboxMessage message) {
    if (Platform.isAndroid) {
      _androidInbox.deleteMessage(message);
    } else if (Platform.isIOS) {
      _iOSInbox.deleteMessage(message);
    }
  }

  Future<InboxData?> fetchAllMessages() async {
    if (Platform.isAndroid) {
      return _androidInbox.fetchAllMessages();
    } else if (Platform.isIOS) {
      return _iOSInbox.fetchAllMessages();
    }
    return null;
  }

  Future<int> getUnClickedCount() async {
    int count = 0;
    if (Platform.isAndroid) {
      count = await _androidInbox.getUnClickedCount();
    } else if (Platform.isIOS) {
      count = await _iOSInbox.getUnClickedCount();
    }
    return count;
  }
}
