import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/action/action.dart';
import 'package:moengage_cards/src/model/navigation_type.dart';

import '../enums/action_type.dart';

class NavigationAction extends Action {
  /// Type of Navigation action.
  ///
  /// Possible value deepLinking or screenName or richLanding
  NavigationType navigationType;

  /// Value can be Deeplink Url, RichLanding Url or Screen Name
  String value;

  /// [Map] of Key-Value pairs entered on the MoEngage Platform for
  /// navigation action of the campaign.
  Map<String, dynamic> keyValuePairs;

  NavigationAction(
      {required ActionType actionType,
      required this.navigationType,
      required this.value,
      required this.keyValuePairs})
      : super(actionType);

  factory NavigationAction.fromJson(Map<String, dynamic> json) {
    return NavigationAction(
        actionType: ActionType.navigate,
        navigationType: NavigationType.values.byName(json[keyNavigationType]),
        value: json[keyActionValue],
        keyValuePairs: json[keyKVPairs]);
  }

  @override
  String toString() {
    return 'NavigationAction{navigationType: $navigationType, value: $value, keyValuePairs: $keyValuePairs}';
  }

  @override
  Map<String, dynamic> toJson() => {
        keyActionType: actionType.name,
        keyNavigationType: navigationType.name,
        keyActionValue: value,
        keyKVPairs: keyValuePairs
      };
}
