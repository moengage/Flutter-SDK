import 'package:moengage_flutter/constants.dart';

class SelfHandled {

  String campaignContent;
  int dismissInterval;
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
        "campaignContent:" + campaignContent + "\n" +
        "dismissInterval:" + dismissInterval.toString() + "\n" +
        "cancellable:" + cancellable.toString() + "\n" +
        "}";
  }
}