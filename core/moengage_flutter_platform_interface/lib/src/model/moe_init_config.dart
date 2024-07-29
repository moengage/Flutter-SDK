import '../model/analytics/analytics_config.dart';
import '../model/push/push_config.dart';

/// Init Config instance to be passed during initialization. If it is not passed
/// default values will be used.
class MoEInitConfig {
  /// [MoEInitConfig] Constructor
  MoEInitConfig({required this.pushConfig, AnalyticsConfig? analyticsConfig})
      : analyticsConfig = analyticsConfig ?? AnalyticsConfig.defaultConfig();

  /// Named Constructor with Default Config
  MoEInitConfig.defaultConfig() : this(pushConfig: PushConfig.defaultConfig());

  /// Instance of [PushConfig] - Configuration for Handling Push Notification
  PushConfig pushConfig;

  /// Instance of [AnalyticsConfig] - Configuration for Handling Data Tracking
  AnalyticsConfig analyticsConfig;
}
