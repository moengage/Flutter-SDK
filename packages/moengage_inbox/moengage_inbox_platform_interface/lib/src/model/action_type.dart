/// Action Type for [InboxMessage]
enum ActionType {
  /// Navigation Action
  navigation
}

/// Extension functions for [ActionType]
extension ActionTypeExt on ActionType {
  /// Convert [ActionType] to [String]
  String get asString {
    switch (this) {
      case ActionType.navigation:
        return _valueNavigation;
    }
  }

  /// Get [ActionType] from [String]
  static ActionType fromString(String string) {
    switch (string) {
      case _valueNavigation:
        return ActionType.navigation;
    }
    throw Exception('unsupported type');
  }
}

const String _valueNavigation = 'navigation';
