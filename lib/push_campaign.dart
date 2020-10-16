import 'constants.dart';

class PushCampaign {

  String platform;
  bool isDefaultAction;
  Map<String, dynamic> clickedAction;
  Map<String, dynamic> payload;

  PushCampaign(Map<String, dynamic> pushCampaign) {
    if (pushCampaign.containsKey(keyPlatform)) {
      this.platform = pushCampaign[keyPlatform];
    }
    if (pushCampaign.containsKey(keyIsDefaultAction)) {
      this.isDefaultAction = pushCampaign[keyIsDefaultAction];
    }
    if (pushCampaign.containsKey(keyClickedAction)) {
      this.clickedAction = pushCampaign[keyClickedAction];
    }
    if (pushCampaign.containsKey(keyPayload)) {
      this.payload = pushCampaign[keyPayload];
    }
  }

  Map<String, dynamic> toJSON() {

  }


}