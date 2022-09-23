import 'package:moengage_flutter/constants.dart';

class PushCampaign {
  bool isDefaultAction;
  Map<String, dynamic> clickedAction;
  Map<String, dynamic> payload;

  PushCampaign(this.isDefaultAction, this.clickedAction, this.payload);

  Map<String, dynamic> toMap() {
    return {
      keyIsDefaultAction: isDefaultAction,
      keyClickedAction: clickedAction,
      keyPayload: payload
    };
  }

  String toString() {
    return "{\n" +
        "isDefaultAction: ${isDefaultAction.toString()}" +
        "\n" +
        "clickedAction: ${clickedAction.toString()}" +
        "\n" +
        "payload: ${payload.toString()}" +
        "\n" +
        "}";
  }
}
