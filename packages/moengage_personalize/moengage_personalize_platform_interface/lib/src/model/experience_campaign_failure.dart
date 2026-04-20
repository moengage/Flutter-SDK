import 'experience_failure_reason.dart';

/// Represents a failure for one or more experience keys.
class ExperienceCampaignFailure {
  /// [ExperienceCampaignFailure] Constructor
  ExperienceCampaignFailure({
    required this.reason,
    required this.experienceKeys,
  });

  /// Failure reason code.
  final ExperienceFailureReason reason;

  /// List of experience keys that failed.
  final List<String> experienceKeys;

  @override
  String toString() {
    return 'ExperienceCampaignFailure{reason: $reason, experienceKeys: $experienceKeys}';
  }
}
