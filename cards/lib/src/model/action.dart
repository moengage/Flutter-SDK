import 'package:moengage_cards/src/model/action_type.dart';

//Base class all Action.
abstract class Action {
  ActionType actionType;

  Action(this.actionType);

  //Abstract Function, should be overridden by Implementation Class
  Map<String, dynamic> toJson();
}
