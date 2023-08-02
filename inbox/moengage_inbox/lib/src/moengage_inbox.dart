import 'dart:async';

import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';

class MoEngageInbox {
  MoEngageInbox(this.appId);
  late String appId;

  void trackMessageClicked(InboxMessage message) {
    MoEngageInboxPlatform.instance.trackMessageClicked(message, appId);
  }

  void deleteMessage(InboxMessage message) {
    MoEngageInboxPlatform.instance.trackMessageClicked(message, appId);
  }

  Future<InboxData?> fetchAllMessages() async {
    return MoEngageInboxPlatform.instance.fetchAllMessages(appId);
  }

  Future<int> getUnClickedCount() async {
    return MoEngageInboxPlatform.instance.getUnClickedCount(appId);
  }
}
