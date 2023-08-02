import '../model/push/push_config.dart';

/// Init Config instance to be passed during initialization. If it is not passed
/// default values will be used.
class MoEInitConfig {
  MoEInitConfig({required this.pushConfig});

  MoEInitConfig.defaultConfig() : this(pushConfig: PushConfig.defaultConfig());

  /// Instance of [PushConfig] - Configuration for Handling Push Notification
  PushConfig pushConfig;
}
