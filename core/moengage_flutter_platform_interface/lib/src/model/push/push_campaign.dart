import '../../constants.dart';

class PushCampaign {
  PushCampaign(this.isDefaultAction, this.clickedAction, this.payload,
      this.selfHandledPushRedirection);
  bool isDefaultAction;
  Map<String, dynamic> clickedAction;
  Map<String, dynamic> payload;

  /// If true, MoEngage SDK will not handle Push redirection for Screen name
  /// and DeepLinking Push Notifications. Client should handle redirection.
  bool selfHandledPushRedirection = false;

  Map<String, dynamic> toMap() {
    return {
      keyIsDefaultAction: isDefaultAction,
      keyClickedAction: clickedAction,
      keyPayload: payload,
      keySelfHandledPushRedirection: selfHandledPushRedirection
    };
  }

  @override
  String toString() {
    return '{\nisDefaultAction: ${isDefaultAction.toString()}\nclickedAction: ${clickedAction.toString()}\npayload: ${payload.toString()}\nselfHandledPushRedirection: $selfHandledPushRedirection \n}';
  }
}
