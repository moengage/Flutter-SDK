/// Status of an experience campaign.
enum ExperienceStatus {
  /// Campaign is currently active.
  active('active'),

  /// Campaign is paused.
  paused('paused'),

  /// Campaign is scheduled for future activation.
  scheduled('scheduled');

  const ExperienceStatus(this.value);

  /// JSON string representation of this status.
  final String value;

  /// Get [ExperienceStatus] from a JSON string value.
  ///
  /// Falls back to [ExperienceStatus.active] for unknown values
  /// so new server-side statuses do not crash older SDK versions.
  static ExperienceStatus fromString(String str) =>
      ExperienceStatus.values.firstWhere(
        (s) => s.value == str,
        orElse: () => ExperienceStatus.active,
      );
}
