/// Analytics Config
class AnalyticsConfig {
  /// [AnalyticsConfig] Constructor
  AnalyticsConfig({required this.shouldTrackUserAttributeBooleanAsNumber});

  /// [AnalyticsConfig] Default Named Constructor
  AnalyticsConfig.defaultConfig()
      : this(shouldTrackUserAttributeBooleanAsNumber: false);

  /// If [shouldTrackUserAttributeBooleanAsNumber] is true,
  /// boolean values in user-attributes are tracked as 0/1 in iOS
  /// instead of false/true respectively.
  bool shouldTrackUserAttributeBooleanAsNumber;
}
