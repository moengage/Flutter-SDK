/// Context of InApp Campaign
class CampaignContext {
  /// [CampaignContext] Constructor
  CampaignContext(this.formattedCampaignId, this.attributes);

  /// Formatted Campaign Id
  String formattedCampaignId;

  /// Campaign Attributes
  Map<String, dynamic> attributes;

  @override
  String toString() {
    return '{\nformattedCampaignId: $formattedCampaignId\nattributes: $attributes\n}';
  }
}
