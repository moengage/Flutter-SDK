import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/inapp/action.dart';

class CustomAction extends Action {
  ///Key-Value Pair entered on the MoEngage Platform during campaign creation.
  Map<String, dynamic> keyValuePair;

  CustomAction(actionType, this.keyValuePair): super(actionType);

  Map<String, dynamic> toMap() {
    return {
      keyKvPair: this.keyValuePair,
    };
  }

  String toString() {
    return "{\n" + "keyValuePairs:" + keyValuePair.toString() + "\n" + "}";
  }
}
