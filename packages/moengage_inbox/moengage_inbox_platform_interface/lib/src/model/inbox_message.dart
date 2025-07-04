import 'action.dart';
import 'media.dart';
import 'text_content.dart';

/// Data object for Inbox Messages
class InboxMessage {
  /// [InboxMessage] Constructor
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
      this.payload,
      this.groupKey,
      this.notificationId,
      this.sentTime);

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

  /// A key representing the group to which the inbox message belongs.
  String groupKey;

  /// Notification Replacement Id.
  String notificationId;

  /// The timestamp indicating when the message was sent.
  ///
  /// Format - ISO-8601 yyyy-MM-dd'T'HH:mm:ss'Z'
  String sentTime;

  @override
  String toString() {
    return 'InboxMessage{id: $id, campaignId: $campaignId, textContent: $textContent, isClicked: $isClicked, media: $media, action: $action, tag: $tag, receivedTime: $receivedTime, expiry: $expiry, payload: $payload, payload: $payload, groupKey: $groupKey, notificationId: $notificationId, sentTime: $sentTime}';
  }
}
