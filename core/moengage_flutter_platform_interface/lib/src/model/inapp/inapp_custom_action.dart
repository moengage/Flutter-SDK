import '../../constants.dart';
import '../inapp/action.dart';

class CustomAction extends Action {
  CustomAction(super.actionType, this.keyValuePairs);

  ///Key-Value Pair entered on the MoEngage Platform during campaign creation.
  Map<String, dynamic> keyValuePairs;

  Map<String, dynamic> toMap() {
    return {
      keyActionType: actionType,
      keyKvPair: keyValuePairs,
    };
  }

  @override
  String toString() {
    return '{\nactionType: $actionType\nkeyValuePairs: $keyValuePairs\n}';
  }
}
