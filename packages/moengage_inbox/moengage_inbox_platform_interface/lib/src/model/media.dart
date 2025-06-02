import 'media_type.dart';
import 'accessibility.dart';

/// Media associated with the [InboxMessage]
class Media {
  /// [Media] constructor
  Media(this.mediaType, this.url, [this.accessibility]);

  /// Content type of the Media.
  MediaType mediaType;

  /// Url for the media content. Generally a http(s) url.
  String url;

  /// Defines the accessibility properties for the media model
  Accessibility? accessibility;

  @override
  String toString() {
    return 'Media{mediaType: $mediaType, url: $url, accessibility: $accessibility}';
  }
}
