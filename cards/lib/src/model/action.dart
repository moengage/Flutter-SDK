
import 'package:moengage_cards/src/model/action_type.dart';

abstract class Action {
  ActionType actionType;

  Action(this.actionType);

  Map<String,dynamic> toJson();
}
