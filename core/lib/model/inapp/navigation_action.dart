import 'package:moengage_flutter/model/inapp/action.dart';
import 'package:moengage_flutter/model/inapp/inapp_action_type.dart';
import 'package:moengage_flutter/model/inapp/navigation_type.dart';

class NavigationAction extends Action {
  /// Type of Navigation action.
  ///
  /// Possible value deep_linking or screen
  NavigationType navigationType;

  /// Deeplink Url or the Screen Name used for the action.
  String url;

  /// [Map] of Key-Value pairs entered on the MoEngage Platform for
  /// navigation action of the campaign.
  Map<String, dynamic> keyValuePairs;

  NavigationAction(
      ActionType actionType, this.navigationType, this.url, this.keyValuePairs)
      : super(actionType);

  String toString() {
    return "{\n" +
        "actionType: ${actionType.toString()}" +
        "\n" +
        "navigationType: ${navigationType.toString()}" +
        "\n" +
        "url: $url" +
        "\n" +
        "keyValuePairs: ${keyValuePairs.toString()}" +
        "\n" +
        "}";
  }
}
