/// Push Notification Config
class PushConfig {
  /// [PushConfig] Constructor
  PushConfig({required this.shouldDeliverCallbackOnForegroundClick});

  /// [PushConfig] Default Named Constructor
  PushConfig.defaultConfig()
      : this(shouldDeliverCallbackOnForegroundClick: false);

  /// If [shouldDeliverCallbackOnForegroundClick] is true, when push notification
  /// is clicked on app foreground, MoEngage SDK will not handle the redirection.
  bool shouldDeliverCallbackOnForegroundClick;
}
