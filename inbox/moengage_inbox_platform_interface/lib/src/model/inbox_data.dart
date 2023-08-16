import 'inbox_message.dart';

/// Inbox Messages Data
class InboxData {
  /// [InboxData] Constructor
  InboxData(this.platform, this.messages);

  /// Native platform from which the callback was triggered.
  String platform;

  /// List of [InboxMessage]
  List<InboxMessage> messages;

  @override
  String toString() {
    return 'InboxData{platform: $platform, messages: $messages}';
  }
}
