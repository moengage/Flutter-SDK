import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/method_channel_moengage_inbox.dart';
import 'src/model/inbox_data.dart';
import 'src/model/inbox_message.dart';

export 'src/internal/constants.dart';
export 'src/internal/moe_inbox_utils.dart';

/// The interface that implementations of moengage_inbox must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `MoengageInbox`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [MoEngageInboxPlatform] methods.

export 'src/model/models.dart';
export 'src/payload_transformer.dart';

abstract class MoEngageInboxPlatform extends PlatformInterface {
  /// Constructs a MoengageInboxPlatform.
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

  Future<int> getUnClickedCount(String appId);

  void trackMessageClicked(InboxMessage message, String appId);

  void deleteMessage(InboxMessage message, String appId);

  Future<InboxData?> fetchAllMessages(String appId);
}
