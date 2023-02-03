import 'action.dart';
import 'inapp_action_type.dart';
import 'navigation_type.dart';

class NavigationAction extends Action {
  /// Type of Navigation action.
  ///
  /// Possible value deep_linking or screen
  NavigationType navigationType;

  /// Deeplink Url or the Screen Name used for the action.
  String navigationUrl;

  /// [Map] of Key-Value pairs entered on the MoEngage Platform for
  /// navigation action of the campaign.
  Map<String, dynamic> keyValuePairs;

  NavigationAction(ActionType actionType, this.navigationType,
      this.navigationUrl, this.keyValuePairs)
      : super(actionType);

  String toString() {
    return "{\n" +
        "actionType: ${actionType.toString()}" +
        "\n" +
        "navigationType: ${navigationType.toString()}" +
        "\n" +
        "navigationUrl: $navigationUrl" +
        "\n" +
        "keyValuePairs: ${keyValuePairs.toString()}" +
        "\n" +
        "}";
  }
}
