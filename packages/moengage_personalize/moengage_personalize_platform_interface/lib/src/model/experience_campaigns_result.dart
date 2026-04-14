import 'experience_campaign.dart';
import 'experience_campaign_failure.dart';

/// Response containing fetched experience campaigns and any failures.
class ExperienceCampaignsResult {
  /// [ExperienceCampaignsResult] Constructor
  ExperienceCampaignsResult({
    required this.experiences,
    required this.failures,
  });

  /// Successfully resolved experience campaigns.
  final List<ExperienceCampaign> experiences;

  /// Failures for experience keys that could not be resolved.
  final List<ExperienceCampaignFailure> failures;

  @override
  String toString() {
    return 'ExperienceCampaignsResult{experiences: $experiences, failures: $failures}';
  }
}
