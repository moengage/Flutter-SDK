import '../../internal/constants.dart';
import '../enums/action_type.dart';
import '../navigation_type.dart';
import 'action.dart';

/// Navigation Action Data
class NavigationAction extends Action {
  /// [NavigationAction] constructor
  NavigationAction({
    required ActionType actionType,
    required this.navigationType,
    required this.value,
    required this.keyValuePairs,
  }) : super(actionType);

  /// Get [NavigationAction] from Json [Map]
  factory NavigationAction.fromJson(Map<String, dynamic> json) {
    return NavigationAction(
      actionType: ActionType.navigate,
      navigationType:
          NavigationType.values.byName(json[keyNavigationType] as String),
      value: (json[keyActionValue] ?? '') as String,
      keyValuePairs: (json[keyKVPairs]) as Map<String, dynamic>,
    );
  }

  /// Type of Navigation action.
  ///
  /// Possible value deepLinking or screenName or richLanding
  NavigationType navigationType;

  /// Value can be Deeplink Url, RichLanding Url or Screen Name
  String value;

  /// [Map] of Key-Value pairs entered on the MoEngage Platform for
  /// navigation action of the campaign.
  Map<String, dynamic> keyValuePairs;

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
