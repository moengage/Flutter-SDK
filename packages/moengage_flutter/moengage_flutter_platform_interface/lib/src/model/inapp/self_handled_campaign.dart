import 'display_rules.dart';

/// Self Handled Inpp Campaign Data
class SelfHandledCampaign {
  /// [SelfHandledCampaign] Constructor
  SelfHandledCampaign(this.payload, this.dismissInterval, this.displayRules);

  /// Self handled campaign payload.
  String payload;

  /// Interval after which in-app should be dismissed, unit - Seconds
  int dismissInterval;

  /// InApp Campaign Display Rules
  Rules displayRules;

  @override
  String toString() {
    return 'SelfHandledCampaign{payload: $payload, dismissInterval: $dismissInterval, rules: $displayRules}';
  }
}
