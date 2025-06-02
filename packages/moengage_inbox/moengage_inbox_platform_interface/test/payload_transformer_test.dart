import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';
import 'package:moengage_inbox_platform_interface/src/model/accessibility.dart';
import 'package:moengage_inbox_platform_interface/src/model/media.dart';

void main() {
  group('accessibilityFromMap', () {
    test('returns null for an empty map', () {
      final result = accessibilityFromMap({});
      expect(result, isNull);
    });

    test('returns Accessibility with provided text and hint', () {
      final testMap = <String, dynamic>{
        keyText: 'Accessible Text',
        keyHint: 'Accessible Hint',
      };
      final result = accessibilityFromMap(testMap);
      expect(result, isNotNull);
      expect(result?.text, equals('Accessible Text'));
      expect(result?.hint, equals('Accessible Hint'));
    });

    test('returns Accessibility with empty string when keyHint is missing', () {
      final testMap = <String, dynamic>{
        keyText: 'Text Only',
      };
      final result = accessibilityFromMap(testMap);
      expect(result, isNotNull);
      expect(result?.text, equals('Text Only'));
      expect(result?.hint, isNull);
    });

    test('returns Accessibility with empty strings when both keys are missing', () {
      // Non-empty map but without keyText and keyHint.
      final testMap = <String, dynamic>{'dummy': 'value'};
      final result = accessibilityFromMap(testMap);
      expect(result, isNotNull);
      expect(result?.text, isNull);
      expect(result?.hint, isNull);
    });
  });

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
      expect(result.accessibility, isNull);
    });

    test('returns Media with null accessibility when keyAccessibility is null', () {
      final accessibilityMap = <String, dynamic>{
        keyText: null,
        keyHint: null
      };
      final mediaMap = <String, dynamic>{
        keyType: 'video',
        keyUrl: 'http://example.com/video.mp4',
        keyAccessibility: accessibilityMap,
      };
      final result = mediaFromMap(mediaMap);
      expect(result, isNotNull);
      expect(result!.mediaType.asString, equals('video'));
      expect(result.url, equals('http://example.com/video.mp4'));
      expect(result.accessibility, isNotNull);
      expect(result.accessibility?.text, isNull);
      expect(result.accessibility?.hint, isNull);
    });

    test('returns Media with accessibility when keyAccessibility is provided', () {
      final accessibilityMap = <String, dynamic>{
        keyText: 'Media Text',
        keyHint: 'Media Hint',
      };
      final mediaMap = <String, dynamic>{
        keyType: 'audio',
        keyUrl: 'http://example.com/audio.mp3',
        keyAccessibility: accessibilityMap,
      };
      final result = mediaFromMap(mediaMap);
      expect(result, isNotNull);
      expect(result!.mediaType.asString, equals('audio'));
      expect(result.url, equals('http://example.com/audio.mp3'));
      expect(result.accessibility, isNotNull);
      expect(result.accessibility?.text, equals('Media Text'));
      expect(result.accessibility?.hint, equals('Media Hint'));
    });
  });

  group('mapFromAccessibility', () {
    test('returns map with null values when accessibility is null', () {
      final result = mapFromAccessibility(null);
      expect(result, isA<Map<String, String?>>());
      expect(result[keyText], isNull);
      expect(result[keyHint], isNull);
    });

    test('returns map with provided accessibility values', () {
      final accessibility = Accessibility('Sample Text', 'Sample Hint');
      final result = mapFromAccessibility(accessibility);
      expect(result, isA<Map<String, String?>>());
      expect(result[keyText], equals('Sample Text'));
      expect(result[keyHint], equals('Sample Hint'));
    });
  });

  group('mapFromMedia', () {
    test('returns map with null accessibility when media.accessibility is null', () {
      final media = Media(MediaTypeExt.fromString('image'), 'http://example.com/image.png', Accessibility(null, null));
      final result = mapFromMedia(media);
      expect(result, isA<Map<String, dynamic>>());
      expect(result[keyType], equals('image'));
      expect(result[keyUrl], equals('http://example.com/image.png'));
      expect(result[keyAccessibility], isA<Map<String, String?>>());
      expect(result[keyAccessibility][keyText], isNull);
      expect(result[keyAccessibility][keyHint], isNull);
    });

    test('returns map with provided accessibility when media.accessibility is provided', () {
      final accessibility = Accessibility('Media Text', 'Media Hint');
      final media = Media(MediaTypeExt.fromString('audio'), 'http://example.com/audio.mp3', accessibility);
      final result = mapFromMedia(media);
      expect(result, isA<Map<String, dynamic>>());
      expect(result[keyType], equals('audio'));
      expect(result[keyUrl], equals('http://example.com/audio.mp3'));
      expect(result[keyAccessibility], isA<Map<String, String?>>());
      expect(result[keyAccessibility][keyText], equals('Media Text'));
      expect(result[keyAccessibility][keyHint], equals('Media Hint'));
    });
  });
}
