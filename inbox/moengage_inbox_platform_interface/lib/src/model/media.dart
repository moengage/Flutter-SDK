import 'media_type.dart';

class Media {
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
