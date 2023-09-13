/// Navigation Type for Inbox Action
enum NavigationType {
  /// DeepLinking Action
  deepLink,

  /// RichLanding Action
  richLanding,

  /// Screen Name Action
  screenName
}

/// Extension for [NavigationType]
extension NavigationTypeExt on NavigationType {
  /// Convert [NavigationType] to String
  String get asString {
    switch (this) {
      case NavigationType.deepLink:
        return _valueDeepLink;
      case NavigationType.screenName:
        return _valueScreenName;
      case NavigationType.richLanding:
        return _valueRichLanding;
    }
  }

  /// Get [NavigationType] From String
  static NavigationType fromString(String string) {
    switch (string) {
      case _valueRichLanding:
        return NavigationType.richLanding;
      case _valueDeepLink:
        return NavigationType.deepLink;
      case _valueScreenName:
        return NavigationType.screenName;
    }
    throw Exception('unsupported type');
  }
}

const String _valueDeepLink = 'deepLink';
const String _valueRichLanding = 'richLanding';
const String _valueScreenName = 'screenName';
