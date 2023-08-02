class CampaignContext {
  CampaignContext(this.formattedCampaignId, this.attributes);
  String formattedCampaignId;
  Map<String, dynamic> attributes;

  @override
  String toString() {
    return '{\nformattedCampaignId: $formattedCampaignId\nattributes: ${attributes.toString()}\n}';
  }
}
