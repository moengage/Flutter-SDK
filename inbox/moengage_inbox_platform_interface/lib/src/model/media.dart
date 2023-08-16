import '../../moengage_inbox_platform_interface.dart';

/// Media associated with the [InboxMessage]
class Media {
  /// [Media] constructor
  Media(this.mediaType, this.url);

  /// Content type of the Media.
  MediaType mediaType;

  /// Url for the media content. Generally a http(s) url.
  String url;

  @override
  String toString() {
    return 'Media{mediaType: $mediaType, url: $url}';
  }
}
