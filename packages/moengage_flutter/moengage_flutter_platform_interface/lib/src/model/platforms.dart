import 'dart:io';

/// Type of Platform
enum Platforms {
  /// Android Platform
  android,

  /// Platform IOS
  iOS
}

/// Extension for  [Platforms]
extension PlatformsExtension on Platforms {
  /// Convert [Platforms] to String
  String get asString {
    switch (this) {
      case Platforms.android:
        return _platformAndroid;
      case Platforms.iOS:
        return _platformIOS;
    }
  }

  /// Get [Platforms] instance From String
  static Platforms fromString(String platform) {
    switch (platform) {
      case _platformIOS:
        return Platforms.iOS;
      case _platformAndroid:
        return Platforms.android;
      default:
        throw Exception(
            'Platforms.fromString() $platform not a valid platform type.');
    }
  }
}

/// Get Current Platform
String? getPlatform() {
  if (Platform.isAndroid) {
    return _platformAndroid;
  } else if (Platform.isIOS) {
    return _platformIOS;
  }
  return null;
}

const String _platformAndroid = 'android';
const String _platformIOS = 'iOS';
