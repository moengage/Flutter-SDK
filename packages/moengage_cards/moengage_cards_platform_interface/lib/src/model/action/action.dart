import '../enums/action_type.dart';

///Base class all Action.
abstract class Action {
  /// [Action] constructor
  Action(this.actionType);

  /// Action Type - Currently Only Navigation Action is Supported
  ActionType actionType;

  /// Abstract Function, should be overridden by Implementation Class
  Map<String, dynamic> toJson();
}
