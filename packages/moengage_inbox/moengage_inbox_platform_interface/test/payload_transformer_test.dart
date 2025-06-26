import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show AccessibilityData, keyAccessibility;
import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';


void main() {
  group('mediaFromMap', () {
    test('returns null for an empty map', () {
      final result = mediaFromMap({});
      expect(result, isNull);
    });

    test('returns Media with null accessibility when keyAccessibility is missing', () {
      final mediaMap = <String, dynamic>{
        keyType: 'image',
        keyUrl: 'http://example.com/image.png'
      };
      final result = mediaFromMap(mediaMap);
      expect(result, isNotNull);
      expect(result!.mediaType.asString, equals('image'));
      expect(result.url, equals('http://example.com/image.png'));
      expect(result.accessibilityData, isNull);
    });

    test('returns Media with null accessibility when keyAccessibility is null', () {
      final accessibility = AccessibilityData(null, null);
      final accessibilityMap = accessibility.toJson();
      final mediaMap = <String, dynamic>{
        keyType: 'video',
        keyUrl: 'http://example.com/video.mp4',
        keyAccessibility: accessibilityMap,
      };
      final result = mediaFromMap(mediaMap);
      expect(result, isNotNull);
      expect(result!.mediaType.asString, equals('video'));
      expect(result.url, equals('http://example.com/video.mp4'));
      expect(result.accessibilityData, isNotNull);
      expect(result.accessibilityData?.text, isNull);
      expect(result.accessibilityData?.hint, isNull);
    });

    test('returns Media with accessibility when keyAccessibility is provided', () {
      final accessibility = AccessibilityData('Media Text', 'Media Hint');
      final accessibilityMap = accessibility.toJson();
      final mediaMap = <String, dynamic>{
        keyType: 'audio',
        keyUrl: 'http://example.com/audio.mp3',
        keyAccessibility: accessibilityMap,
      };
      final result = mediaFromMap(mediaMap);
      expect(result, isNotNull);
      expect(result!.mediaType.asString, equals('audio'));
      expect(result.url, equals('http://example.com/audio.mp3'));
      expect(result.accessibilityData, isNotNull);
      expect(result.accessibilityData?.text, equals('Media Text'));
      expect(result.accessibilityData?.hint, equals('Media Hint'));
    });
  });

  group('mapFromMedia', () {
    test('returns map with null accessibility when media.accessibility is null', () {
      final media = Media(MediaTypeExt.fromString('image'), 'http://example.com/image.png', AccessibilityData(null, null));
      final result = mapFromMedia(media);
      expect(result, isA<Map<String, dynamic>>());
      expect(result[keyType], equals('image'));
      expect(result[keyUrl], equals('http://example.com/image.png'));
      expect(result[keyAccessibility], isA<Map<String, String?>>());
      expect(result[keyAccessibility]['text'], isNull);
      expect(result[keyAccessibility]['hint'], isNull);
    });

    test('returns map with provided accessibility when media.accessibility is provided', () {
      final accessibility = AccessibilityData('Media Text', 'Media Hint');
      final media = Media(MediaTypeExt.fromString('audio'), 'http://example.com/audio.mp3', accessibility);
      final result = mapFromMedia(media);
      expect(result, isA<Map<String, dynamic>>());
      expect(result[keyType], equals('audio'));
      expect(result[keyUrl], equals('http://example.com/audio.mp3'));
      expect(result[keyAccessibility], isA<Map<String, String?>>());
      expect(result[keyAccessibility]['text'], equals('Media Text'));
      expect(result[keyAccessibility]['hint'], equals('Media Hint'));
    });
  });
}
