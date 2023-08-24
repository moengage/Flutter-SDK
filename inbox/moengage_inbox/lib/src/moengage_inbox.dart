import 'dart:async';

import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';

/// Helper Class to interact with MoEngage Cards Feature
class MoEngageInbox {
  /// [MoEngageInbox] Constructor
  MoEngageInbox(this.appId);

  /// AppId Available in MoEngage Platform
  late String appId;

  ///Marks the given message as clicked and tracks a click event for the same.
  /// [message] - [InboxMessage] data
  void trackMessageClicked(InboxMessage message) {
    MoEngageInboxPlatform.instance.trackMessageClicked(message, appId);
  }

  /// Deletes the given message from inbox.
  /// [message] - [InboxMessage] data
  void deleteMessage(InboxMessage message) {
    MoEngageInboxPlatform.instance.trackMessageClicked(message, appId);
  }

  /// Gets all the messages saved in the inbox
  /// Returns [List] of [InboxData]
  Future<InboxData?> fetchAllMessages() async {
    return MoEngageInboxPlatform.instance.fetchAllMessages(appId);
  }

  /// Returns the count of un-clicked messages in the inbox
  Future<int> getUnClickedCount() async {
    return MoEngageInboxPlatform.instance.getUnClickedCount(appId);
  }
}
