///Push Notification Config
class PushConfig {
  /** If [shouldDeliverCallbackOnForegroundClick] is true, when push notification
   * is clicked on app foreground, MoEngage SDK will not handle the redirection.
   * **/
  bool shouldDeliverCallbackOnForegroundClick;

  PushConfig({required this.shouldDeliverCallbackOnForegroundClick});

  PushConfig.defaultConfig()
      : this(shouldDeliverCallbackOnForegroundClick: false);
}
