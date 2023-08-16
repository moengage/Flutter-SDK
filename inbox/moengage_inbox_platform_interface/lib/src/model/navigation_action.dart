import 'action.dart';
import 'navigation_type.dart';

/// Navigation Action
class NavigationAction extends Action {
  /// [NavigationAction] Constructor
  NavigationAction(
      super.actionType, this.navigationType, this.value, this.kvPair);

  /// Navigation Type
  NavigationType navigationType;

  /// Url or screen name to navigate to
  String value;

  /// Additional Key value pair associated with action
  Map<String, dynamic> kvPair;

  @override
  String toString() {
    return 'NavigationAction{navigationType: $navigationType, value: $value, kvPair: $kvPair}';
  }
}
