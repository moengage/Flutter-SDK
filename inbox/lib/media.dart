import 'package:moengage_inbox/media_type.dart';

class Media {
  /// Content type of the Media.
  MediaType mediaType;

  /// Url for the media content. Generally a http(s) url.
  String url;

  Media(this.mediaType, this.url);

  @override
  String toString() {
    return 'Media{mediaType: $mediaType, url: $url}';
  }
}
