class TextContent {
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

  TextContent(this.title, this.message, this.summary, this.subtitle);

  String toString() {
    return "title: $title, message: $message,  summary: $summary, subtitle: $subtitle";
  }
}
