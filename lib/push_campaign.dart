import 'constants.dart';

class PushCampaign {

  String platform;
  bool isDefaultAction;
  Map<String, dynamic> clickedAction;
  Map<String, dynamic> payload;

  PushCampaign(this.platform, this.isDefaultAction, this.clickedAction,
      this.payload);

  Map<String, dynamic> toJSON() {
    return {
      keyPlatform: platform,
      keyIsDefaultAction: isDefaultAction,
      keyClickedAction: clickedAction,
      keyPayload: payload
    };
  }

  String toString() {
    return "{\n" +
        "platform:" + platform + "\n" +
        "isDefaultAction:" + isDefaultAction.toString() + "\n" +
        "clickedAction:" + clickedAction.toString() + "\n" +
        "payload:" + payload.toString() + "\n" +
        "}";
  }
}