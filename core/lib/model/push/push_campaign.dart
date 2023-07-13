import 'package:moengage_flutter/constants.dart';

class PushCampaign {
  bool isDefaultAction;
  Map<String, dynamic> clickedAction;
  Map<String, dynamic> payload;

  /// If true, MoEngage SDK will not handle Push redirection for Screen name
  /// and DeepLinking Push Notifications. Client should handle redirection.
  bool selfHandledPushRedirection = false;

  PushCampaign(this.isDefaultAction, this.clickedAction, this.payload,
      this.selfHandledPushRedirection);

  Map<String, dynamic> toMap() {
    return {
      keyIsDefaultAction: isDefaultAction,
      keyClickedAction: clickedAction,
      keyPayload: payload,
      keySelfHandledPushRedirection: selfHandledPushRedirection
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
        "selfHandledPushRedirection: $selfHandledPushRedirection \n"
            "}";
  }
}
