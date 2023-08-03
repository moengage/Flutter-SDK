import '../inapp/inapp_action_type.dart';

/// InApp Base Action
abstract class Action {
  /// Base Constructor for Action
  Action(this.actionType);

  /// Type of Action
  ActionType actionType;
}
