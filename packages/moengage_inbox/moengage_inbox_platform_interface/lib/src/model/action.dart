import '../../moengage_inbox_platform_interface.dart';

/// Action Data for [InboxMessage]
class Action {
  /// [Action] Constructor
  Action(this.actionType);

  /// Type of Action
  ActionType actionType;

  @override
  String toString() {
    return 'Action{actionType: $actionType}';
  }
}
