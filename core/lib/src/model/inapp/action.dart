import 'inapp_action_type.dart';

abstract class Action {
  ActionType actionType;

  Action(this.actionType);
}
