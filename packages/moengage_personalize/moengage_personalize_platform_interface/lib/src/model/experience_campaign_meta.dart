import 'experience_status.dart';

/// Metadata for a single experience campaign.
class ExperienceCampaignMeta {
  /// [ExperienceCampaignMeta] Constructor
  ExperienceCampaignMeta({
    required this.experienceKey,
    required this.experienceName,
    required this.status,
  });

  /// Unique key identifying the experience.
  final String experienceKey;

  /// Human-readable name of the experience.
  final String experienceName;

  /// Current status of the experience campaign.
  final ExperienceStatus status;

  @override
  String toString() {
    return 'ExperienceCampaignMeta{experienceKey: $experienceKey, experienceName: $experienceName, status: $status}';
  }
}
