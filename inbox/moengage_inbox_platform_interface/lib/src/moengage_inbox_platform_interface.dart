import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_moengage_inbox.dart';
import 'model/inbox_data.dart';
import 'model/inbox_message.dart';

/// Platform Interface for MoEngage Inbox Feature
abstract class MoEngageInboxPlatform extends PlatformInterface {
  /// Constructs a MoEngageInboxPlatform.
  MoEngageInboxPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngageInboxPlatform _instance = MethodChannelMoEngageInbox();

  /// The default instance of [MoEngageInboxPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoEngageInbox].
  static MoEngageInboxPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MoEngageInboxPlatform] when they register themselves.
  static set instance(MoEngageInboxPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Returns the count of un-clicked messages in the inbox
  /// [appId] - MoEngage App ID
  Future<int> getUnClickedCount(String appId);

  ///Marks the given message as clicked and tracks a click event for the same.
  /// [message] - MoEngage App ID
  /// [appId] - MoEngage App ID
  void trackMessageClicked(InboxMessage message, String appId);

  /// Deletes the given message from inbox.
  /// [message] - [InboxMessage]
  /// [appId] - MoEngage App ID
  void deleteMessage(InboxMessage message, String appId);

  /// Gets all the messages saved in the inbox
  /// [appId] - MoEngage App ID
  Future<InboxData?> fetchAllMessages(String appId);
}
