import 'constants.dart';

class CustomAction {
  Map<String, dynamic> keyValuePair;

  CustomAction(Map<String, dynamic> kvPair) {
    keyValuePair = kvPair;
  }

  Map<String, dynamic> toJSON() {
    return {
      _keyKVPair: keyValuePair.isEmpty? "": keyValuePair
    };
  }

  String _keyKVPair = "kvPair";
}