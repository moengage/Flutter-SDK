import 'action_type.dart';

class Action {
  Action(this.actionType);
  ActionType actionType;

  @override
  String toString() {
    return 'Action{actionType: $actionType}';
  }
}
