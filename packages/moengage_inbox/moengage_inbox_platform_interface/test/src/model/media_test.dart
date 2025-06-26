import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show AccessibilityData;
import 'package:moengage_inbox_platform_interface/src/model/media.dart';
import 'package:moengage_inbox_platform_interface/src/model/media_type.dart';

void main() {
  group('Media', () {
    test('should create Media with non-null accessibility', () {
      final mediaType = MediaType.image;
      final url = 'https://example.com/image.png';
      final accessibility = AccessibilityData('Accessible text', 'Accessible hint');
      final media = Media(mediaType, url, accessibility);

      expect(media.mediaType, equals(mediaType));
      expect(media.url, equals(url));
      expect(media.accessibilityData, equals(accessibility));
    });

    test('should create Media with null accessibility', () {
      final mediaType = MediaType.video;
      final url = 'https://example.com/video.mp4';
      final media = Media(mediaType, url, null);

      expect(media.mediaType, equals(mediaType));
      expect(media.url, equals(url));
      expect(media.accessibilityData, isNull);
    });

    test('toString returns expected string representation', () {
      final mediaType = MediaType.image;
      final url = 'https://example.com/media.png';
      final accessibility = AccessibilityData('Text', 'Hint');
      final media = Media(mediaType, url, accessibility);

      final expectedString =
          'Media{mediaType: $mediaType, url: $url, accessibility: $accessibility}';
      expect(media.toString(), equals(expectedString));
    });
  });
}
