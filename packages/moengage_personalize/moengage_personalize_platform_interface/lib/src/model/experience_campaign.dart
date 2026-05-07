import 'data_source.dart';

/// A fully resolved experience campaign with payload and context.
class ExperienceCampaign {
  /// [ExperienceCampaign] Constructor
  ExperienceCampaign({
    required this.experienceKey,
    required this.payload,
    required this.experienceContext,
    required this.source,
  });

  /// Unique key identifying the experience.
  final String experienceKey;

  /// The experience payload containing personalized content.
  final Map<String, dynamic> payload;

  /// Contextual data associated with the experience.
  final Map<String, String> experienceContext;

  /// Source from which the data was retrieved.
  final DataSource source;

  @override
  String toString() {
    return 'ExperienceCampaign{experienceKey: $experienceKey, payload: $payload, experienceContext: $experienceContext, source: $source}';
  }
}
