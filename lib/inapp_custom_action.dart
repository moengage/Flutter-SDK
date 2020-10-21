import 'constants.dart';

class CustomAction {

  Map<String, dynamic> keyValuePair;

  CustomAction(this.keyValuePair);

  Map<String, dynamic> toMap() {
    return {
      keyKvPair: this.keyValuePair,
    };
  }

  String toString() {
    return "{\n" +
        "keyValuePairs:" + keyValuePair.toString() + "\n" +
        "}";
  }
}