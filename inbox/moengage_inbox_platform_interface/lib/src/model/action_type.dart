enum ActionType { navigation }

extension ActionTypeExt on ActionType {
  String get asString {
    switch (this) {
      case ActionType.navigation:
        return _valueNavigation;
    }
  }

  static ActionType fromString(String string) {
    switch (string) {
      case _valueNavigation:
        return ActionType.navigation;
    }
    throw Exception('unsupported type');
  }
}

const String _valueNavigation = 'navigation';
