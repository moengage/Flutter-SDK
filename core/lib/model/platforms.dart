
enum Platforms { android, iOS }

extension PlatformsExtension on Platforms {
  String get asString {
    switch(this) {
      case Platforms.android:
        return _platformAndroid;
      case Platforms.iOS:
        return _platformiOS;
    }
  }

  static Platforms fromString(String platform) {
    switch(platform) {
      case _platformiOS:
        return Platforms.iOS;
      case _platformAndroid:
        return Platforms.android;
      default:
        throw Exception("Platforms.fromString() $platform not a valid platform type.");
    }
  }
}

const String _platformAndroid = "android";
const String _platformiOS = "iOS";