/// Navigation Types for Navigation Action
enum NavigationType {
  /// Screen Name Navigation
  screenName,

  /// DeepLink Navigation
  deeplink
}

/// Extension for Converting Navigation Type Enum to String
extension NavigationTypeExtension on NavigationType {
  /// Get [NavigationType] from [String]
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
