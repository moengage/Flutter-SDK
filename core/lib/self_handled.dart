import 'package:moengage_flutter/constants.dart';

class SelfHandled {
  /// Self handled campaign payload.
  String campaignContent;

  /// Interval after which in-app should be dismissed, unit - Seconds
  int dismissInterval;

  /// Should the campaign be dismissed by pressing the back button or using
  /// the back gesture. if the value is true campaign should be dismissed on
  /// back press.
  bool cancellable;

  SelfHandled(this.campaignContent, this.dismissInterval, this.cancellable);

  Map<String, dynamic> toMap() {
    return {
      keyPayload: this.campaignContent,
      keyDismissInterval: this.dismissInterval,
      keyIsCancellable: this.cancellable,
    };
  }

  String toString() {
    return "{\n" +
        "campaignContent:" +
        campaignContent +
        "\n" +
        "dismissInterval:" +
        dismissInterval.toString() +
        "\n" +
        "cancellable:" +
        cancellable.toString() +
        "\n" +
        "}";
  }
}
