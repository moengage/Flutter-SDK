import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moengage_inbox/constants.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/inbox_message.dart';
import 'package:moengage_inbox/moe_android_inbox.dart';
import 'package:moengage_inbox/moe_ios_inbox.dart';
import 'package:moengage_inbox/moe_inbox_utils.dart';

class MoEngageInbox {
  late MethodChannel _channel;
  late MoEAndroidInbox _androidInbox;
  late MoEiOSInbox _iOSInbox;
  late String appId;

  MoEngageInbox(this.appId) {
    _channel = MethodChannel(CHANNEL_NAME);
    _androidInbox = MoEAndroidInbox(_channel);
    _iOSInbox = MoEiOSInbox(_channel);
  }

  void trackMessageClicked(InboxMessage message) {
    Map<String, dynamic> payload = getImpressionPayload(message, appId);
    if (Platform.isAndroid) {
      _androidInbox.trackMessageClicked(payload);
    } else if (Platform.isIOS) {
      _iOSInbox.trackMessageClicked(payload);
    }
  }

  void deleteMessage(InboxMessage message) {
    Map<String, dynamic> payload = getImpressionPayload(message, appId);
    if (Platform.isAndroid) {
      _androidInbox.deleteMessage(payload);
    } else if (Platform.isIOS) {
      _iOSInbox.deleteMessage(payload);
    }
  }

  Future<InboxData?> fetchAllMessages() async {
    Map<String, dynamic> payload = getAccountMeta(appId);
    if (Platform.isAndroid) {
      return _androidInbox.fetchAllMessages(payload);
    } else if (Platform.isIOS) {
      return _iOSInbox.fetchAllMessages(payload);
    }
    return null;
  }

  Future<int> getUnClickedCount() async {
    int count = 0;
    Map<String, dynamic> payload = getAccountMeta(appId);
    if (Platform.isAndroid) {
      count = await _androidInbox.getUnClickedCount(payload);
    } else if (Platform.isIOS) {
      count = await _iOSInbox.getUnClickedCount(payload);
    }
    return count;
  }
}
