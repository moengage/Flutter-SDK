/// Self Handled Inpp Campaign Data
class SelfHandledCampaign {
  /// [SelfHandledCampaign] Constructor
  SelfHandledCampaign(this.payload, this.dismissInterval);

  /// Self handled campaign payload.
  String payload;

  /// Interval after which in-app should be dismissed, unit - Seconds
  int dismissInterval;

  @override
  String toString() {
    return '{\npayload: $payload\ndismissInterval: $dismissInterval\n}';
  }
}
