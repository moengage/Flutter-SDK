import '../model/push/push_config.dart';
import 'analytics/analytics_config.dart';

/// Init Config instance to be passed during initialization. If it is not passed
/// default values will be used.
class MoEInitConfig {
  /// [MoEInitConfig] Constructor
  MoEInitConfig({PushConfig? pushConfig, AnalyticsConfig? analyticsConfig})
      : pushConfig = pushConfig ?? PushConfig.defaultConfig(),
        analyticsConfig = analyticsConfig ?? AnalyticsConfig.defaultConfig();

  /// Named Constructor with Default Config
  MoEInitConfig.defaultConfig() : this();

  /// Instance of [PushConfig] - Configuration for Handling Push Notification
  PushConfig pushConfig;

  /// Instance of [AnalyticsConfig] - Configuration for Handling Data Tracking
  AnalyticsConfig analyticsConfig;
}
