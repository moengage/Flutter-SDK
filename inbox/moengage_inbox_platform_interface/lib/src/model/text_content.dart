import '../moengage_inbox_platform_interface.dart';

/// Text Content for [InboxMessage]
class TextContent {
  /// [InboxMessage] Constructor
  TextContent(this.title, this.message, this.summary, this.subtitle);

  /// Title string for the inbox message.
  String title;

  /// Message string for the inbox message.
  String message;

  /// Summary string for the inbox message.
  ///
  /// Note: This is present for Android Platform.
  String summary;

  /// Subtitle string for the inbox message.
  ///
  /// Note: This is present only for the iOS Platform.
  String subtitle;

  @override
  String toString() {
    return 'title: $title, message: $message,  summary: $summary, subtitle: $subtitle';
  }
}
