
import 'package:moengage_flutter/model/inapp/inapp_action_type.dart';

abstract class Action {
  ActionType actionType;

  Action(this.actionType);
}