import 'inbox_message.dart';

class InboxData {
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
