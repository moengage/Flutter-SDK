class NavigationAction {

  String navigationType;
  String url;
  Map<String, dynamic> keyValuePairs;

  NavigationAction(Map<String, dynamic> navigationAction) {
    if (navigationAction.containsKey(_keyNavigationType)) {
      navigationType = navigationAction[_keyNavigationType];
    }
    if (navigationAction.containsKey(_keyValue)) {
      url = navigationAction[_keyValue];
    }
    if (navigationAction.containsKey(_keyKvPair)) {
      keyValuePairs = navigationAction[_keyKvPair];
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      _keyNavigationType: this.navigationType,
      _keyValue: this.url,
      _keyKvPair: this.keyValuePairs,
    };
  }

  String _keyNavigationType = "navigationType";
  String _keyValue = "value";
  String _keyKvPair = "kvPair";
}