import 'package:moengage_inbox/inbox_message.dart';

class InboxData {
  /// Native platform from which the callback was triggered.
  String platform;

  /// List of [InboxMessage]
  List<InboxMessage> messages;

  InboxData(this.platform, this.messages);

  @override
  String toString() {
    return 'InboxData{platform: $platform, messages: $messages}';
  }
}
