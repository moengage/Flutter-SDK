import 'package:moengage_flutter/constants.dart';

class CustomAction {
  ///Key-Value Pair entered on the MoEngage Platform during campaign creation.
  Map<String, dynamic> keyValuePair;

  CustomAction(this.keyValuePair);

  Map<String, dynamic> toMap() {
    return {
      keyKvPair: this.keyValuePair,
    };
  }

  String toString() {
    return "{\n" + "keyValuePairs:" + keyValuePair.toString() + "\n" + "}";
  }
}
