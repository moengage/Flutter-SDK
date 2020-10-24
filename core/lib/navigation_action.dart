import 'package:moengage_flutter/constants.dart';

class NavigationAction {
  /// Type of Navigation action.
  ///
  /// Possible value deep_linking or screen
  String navigationType;

  /// Deeplink Url or the Screen Name used for the action.
  String url;

  /// [Map] of Key-Value pairs entered on the MoEngage Platform for
  /// navigation action of the campaign.
  Map<String, dynamic> keyValuePairs;

  NavigationAction(this.navigationType, this.url, this.keyValuePairs);

  Map<String, dynamic> toMap() {
    return {
      keyNavigationType: this.navigationType,
      keyValue: this.url,
      keyKvPair: this.keyValuePairs,
    };
  }

  String toString() {
    return "{\n" +
        "navigationType:" +
        navigationType +
        "\n" +
        "url:" +
        url +
        "\n" +
        "keyValuePairs:" +
        keyValuePairs.toString() +
        "\n" +
        "}";
  }
}
