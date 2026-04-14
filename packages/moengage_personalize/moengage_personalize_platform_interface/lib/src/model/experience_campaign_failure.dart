/// Represents a failure for one or more experience keys.
class ExperienceCampaignFailure {
  /// [ExperienceCampaignFailure] Constructor
  ExperienceCampaignFailure({
    required this.reason,
    required this.experienceKeys,
    this.message,
  });

  /// Failure reason code string.
  final String reason;

  /// List of experience keys that failed.
  final List<String> experienceKeys;

  /// Optional human-readable error message.
  final String? message;

  @override
  String toString() {
    return 'ExperienceCampaignFailure{reason: $reason, experienceKeys: $experienceKeys, message: $message}';
  }
}
