class CampaignContext {
  String formattedCampaignId;
  Map<String, dynamic> attributes;

  CampaignContext(this.formattedCampaignId, this.attributes);

  String toString() {
    return "{\n" +
        "formattedCampaignId:" +
        formattedCampaignId +
        "\n" +
        "attributes:" +
        attributes.toString() +
        "\n" +
        "}";
  }
}