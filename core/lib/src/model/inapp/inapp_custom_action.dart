import '../../constants.dart';
import 'action.dart';

class CustomAction extends Action {
  ///Key-Value Pair entered on the MoEngage Platform during campaign creation.
  Map<String, dynamic> keyValuePairs;

  CustomAction(actionType, this.keyValuePairs) : super(actionType);

  Map<String, dynamic> toMap() {
    return {
      keyActionType: actionType,
      keyKvPair: this.keyValuePairs,
    };
  }

  String toString() {
    return "{\n" +
        "actionType: ${actionType.toString()}" +
        "\n" +
        "keyValuePairs: ${keyValuePairs.toString()}" +
        "\n" +
        "}";
  }
}
