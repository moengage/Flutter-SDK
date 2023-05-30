import 'package:moengage_cards/src/model/enums/action_type.dart';

///Base class all Action.
abstract class Action {
  /// Action Type - Currently Only Navigation Action is Supported
  ActionType actionType;

  Action(this.actionType);

  //Abstract Function, should be overridden by Implementation Class
  Map<String, dynamic> toJson();
}
