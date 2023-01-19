import 'package:moengage_flutter/model/inapp/action.dart';
import 'package:moengage_flutter/model/inapp/inapp_action_type.dart';

class PushNotificationAction extends Action {
  ActionType actionType;
  int requestCount;

  PushNotificationAction(this.actionType, this.requestCount)
      : super(actionType);
}
