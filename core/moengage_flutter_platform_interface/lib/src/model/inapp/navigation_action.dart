import '../inapp/action.dart';
import '../inapp/navigation_type.dart';

/// Navigation Action Data
class NavigationAction extends Action {
  /// [NavigationAction] Constructor
  NavigationAction(super.actionType, this.navigationType, this.navigationUrl,
      this.keyValuePairs);

  /// Type of Navigation action.
  ///
  /// Possible value deep_linking or screen
  NavigationType navigationType;

  /// Deeplink Url or the Screen Name used for the action.
  String navigationUrl;

  /// [Map] of Key-Value pairs entered on the MoEngage Platform for
  /// navigation action of the campaign.
  Map<String, dynamic> keyValuePairs;

  @override
  String toString() {
    return '{\nactionType: $actionType\nnavigationType: $navigationType\nnavigationUrl: $navigationUrl\nkeyValuePairs: $keyValuePairs\n}';
  }
}
