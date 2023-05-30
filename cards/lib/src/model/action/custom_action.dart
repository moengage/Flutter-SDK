import 'package:moengage_cards/src/internal/constants.dart';

import '../../../moengage_cards.dart';

/// Custom Action
class CustomAction extends Action {
  CustomAction(actionType) : super(actionType);

  @override
  Map<String, dynamic> toJson() => {keyActionType: actionType};

  factory CustomAction.fromJson(Map<String, dynamic> json) {
    return CustomAction(ActionType.custom);
  }
}
