import 'action.dart';
import 'media.dart';
import 'text_content.dart';

class InboxMessage {
  InboxMessage(
      this.id,
      this.campaignId,
      this.textContent,
      this.isClicked,
      this.media,
      this.action,
      this.tag,
      this.receivedTime,
      this.expiry,
      this.payload);

  /// internal identifier used by the SDK for storage.
  int id;

  /// Unique identifier for a message.
  String campaignId;

  /// Text content of the message. Instance of [TextContent]
  TextContent textContent;

  /// true if the message has been clicked by the user else false
  bool isClicked;

  /// Media content associated with the message.
  Media? media;

  /// List of actions to be executed on click.
  List<Action> action;

  /// Tag associated to the message.
  String tag;

  /// The time in which the message was received on the device.
  ///
  /// Format - ISO-8601 yyyy-MM-dd'T'HH:mm:ss'Z'
  String receivedTime;

  /// The time at which the message expiry.
  ///
  /// Format - ISO-8601 yyyy-MM-dd'T'HH:mm:ss'Z'
  String expiry;

  /// Complete message payload.
  Map<String, dynamic> payload;

  @override
  String toString() {
    return 'InboxMessage{id: $id, campaignId: $campaignId, textContent: $textContent, isClicked: $isClicked, media: $media, action: $action, tag: $tag, receivedTime: $receivedTime, expiry: $expiry, payload: $payload}';
  }
}
