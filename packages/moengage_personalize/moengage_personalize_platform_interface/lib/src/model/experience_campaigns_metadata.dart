import 'data_source.dart';
import 'experience_campaign_meta.dart';

/// Response containing metadata for experience campaigns.
class ExperienceCampaignsMetadata {
  /// [ExperienceCampaignsMetadata] Constructor
  ExperienceCampaignsMetadata({
    required this.source,
    required this.experiences,
  });

  /// Source from which the data was retrieved.
  final DataSource source;

  /// List of experience campaign metadata.
  final List<ExperienceCampaignMeta> experiences;

  @override
  String toString() {
    return 'ExperienceCampaignsMetadata{source: $source, experiences: $experiences}';
  }
}
