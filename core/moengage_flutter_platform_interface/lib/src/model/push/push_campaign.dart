import '../../constants.dart';

/// Push Campaign Related Data
class PushCampaign {
  /// [PushCampaign] Constructor
  PushCampaign(this.isDefaultAction, this.clickedAction, this.payload,
      this.selfHandledPushRedirection);

  /// Default Push Click Action
  bool isDefaultAction;

  /// Click Action Data
  Map<String, dynamic> clickedAction;

  /// Campaign payload
  Map<String, dynamic> payload;

  /// If true, MoEngage SDK will not handle Push redirection for Screen name
  /// and DeepLinking Push Notifications. Client should handle redirection.
  bool selfHandledPushRedirection = false;

  /// To Convert [PushCampaign] to [Map]
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
    return '{\nisDefaultAction: $isDefaultAction\nclickedAction: $clickedAction\npayload: $payload\nselfHandledPushRedirection: $selfHandledPushRedirection \n}';
  }
}
