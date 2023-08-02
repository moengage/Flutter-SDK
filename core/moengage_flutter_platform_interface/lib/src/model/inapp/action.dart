import '../inapp/inapp_action_type.dart';

abstract class Action {
  Action(this.actionType);
  ActionType actionType;
}
