import 'constants.dart';

class NavigationAction {

  String navigationType;
  String url;
  Map<String, dynamic> keyValuePairs;

  NavigationAction(this.navigationType, this.url, this.keyValuePairs);

  Map<String, dynamic> toMap() {
    return {
      keyNavigationType: this.navigationType,
      keyValue: this.url,
      keyKvPair: this.keyValuePairs,
    };
  }

  String toString() {
    return "{\n" +
        "navigationType:" + navigationType + "\n" +
        "url:" + url + "\n" +
        "keyValuePairs:" + keyValuePairs.toString() + "\n" +
        "}";
  }
}