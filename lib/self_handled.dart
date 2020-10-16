class SelfHandled {

  String campaignContent;
  int dismissInterval;
  bool cancellable;

  SelfHandled(Map<String, dynamic> selfHandled) {
    if (selfHandled.containsKey(_keyPayload)) {
      campaignContent = selfHandled[_keyPayload];
    }
    if (selfHandled.containsKey(_keyDismissInterval)) {
      cancellable = selfHandled[_keyDismissInterval];
    }
    if (selfHandled.containsKey(_keyIsCancellable)) {
      campaignContent = selfHandled[_keyIsCancellable];
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      _keyPayload: this.campaignContent,
      _keyDismissInterval: this.dismissInterval,
      _keyIsCancellable: this.cancellable,
    };
  }

  String _keyPayload = "payload";
  String _keyDismissInterval = "dismissInterval";
  String _keyIsCancellable = "isCancellable";
}