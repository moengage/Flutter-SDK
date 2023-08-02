import 'action.dart';
import 'navigation_type.dart';

class NavigationAction extends Action {
  NavigationAction(
      super.actionType, this.navigationType, this.value, this.kvPair);

  NavigationType navigationType;

  String value;

  Map<String, dynamic> kvPair;

  @override
  String toString() {
    return 'NavigationAction{navigationType: $navigationType, value: $value, kvPair: $kvPair}';
  }
}
