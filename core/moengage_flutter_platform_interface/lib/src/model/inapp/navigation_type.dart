enum NavigationType { screenName, deeplink }

extension NavigationTypeExtension on NavigationType {
  String get asString {
    switch (this) {
      case NavigationType.screenName:
        return _screenName;
      case NavigationType.deeplink:
        return _deeplink;
    }
  }

  static NavigationType fromString(String navigationType) {
    switch (navigationType) {
      case _screenName:
        return NavigationType.screenName;
      case _deeplink:
        return NavigationType.deeplink;
      default:
        throw Exception(
            'NavigationType.fromString() $navigationType not a valid navigation type.');
    }
  }
}

const String _screenName = 'screen';
const String _deeplink = 'deep_linking';
