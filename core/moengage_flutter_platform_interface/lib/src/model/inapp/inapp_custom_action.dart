import '../inapp/action.dart';

/// Custom Action
class CustomAction extends Action {
  /// [CustomAction] Constructor
  /// [actionType] Instance of [ActionType]
  /// [keyValuePairs] Key Value Pair Data
  CustomAction(super.actionType, this.keyValuePairs);

  ///Key-Value Pair entered on the MoEngage Platform during campaign creation.
  Map<String, dynamic> keyValuePairs;

  @override
  String toString() {
    return '{\nactionType: $actionType\nkeyValuePairs: $keyValuePairs\n}';
  }
}
