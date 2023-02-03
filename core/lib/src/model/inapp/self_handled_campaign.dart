class SelfHandledCampaign {
  /// Self handled campaign payload.
  String payload;

  /// Interval after which in-app should be dismissed, unit - Seconds
  int dismissInterval;

  SelfHandledCampaign(this.payload, this.dismissInterval);

  String toString() {
    return "{\n" +
        "payload: $payload" +
        "\n" +
        "dismissInterval: ${dismissInterval.toString()}" +
        "\n" +
        "}";
  }
}
