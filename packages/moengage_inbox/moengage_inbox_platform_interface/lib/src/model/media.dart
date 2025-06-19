import 'package:moengage_flutter/moengage_flutter.dart' show AccessibilityData;
import 'media_type.dart';

/// Media associated with the [InboxMessage]
class Media {
  /// [Media] constructor
  Media(this.mediaType, this.url, [this.accessibilityData]);

  /// Content type of the Media.
  MediaType mediaType;

  /// Url for the media content. Generally a http(s) url.
  String url;

  /// Defines the accessibility properties for the media model
  AccessibilityData? accessibilityData;

  @override
  String toString() {
    return 'Media{mediaType: $mediaType, url: $url, accessibility: $accessibilityData}';
  }
}
