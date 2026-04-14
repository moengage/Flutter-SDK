/// Status of an experience campaign.
enum ExperienceStatus {
  /// Campaign is currently active.
  active,

  /// Campaign is paused.
  paused,

  /// Campaign is scheduled for future activation.
  scheduled,
}

/// Extension for [ExperienceStatus] serialization.
extension ExperienceStatusExt on ExperienceStatus {
  /// Convert [ExperienceStatus] to its JSON string value.
  String get asString {
    switch (this) {
      case ExperienceStatus.active:
        return _valueActive;
      case ExperienceStatus.paused:
        return _valuePaused;
      case ExperienceStatus.scheduled:
        return _valueScheduled;
    }
  }

  /// Get [ExperienceStatus] from a JSON string value.
  static ExperienceStatus fromString(String value) {
    switch (value) {
      case _valueActive:
        return ExperienceStatus.active;
      case _valuePaused:
        return ExperienceStatus.paused;
      case _valueScheduled:
        return ExperienceStatus.scheduled;
      default:
        return ExperienceStatus.active;
    }
  }
}

const String _valueActive = 'active';
const String _valuePaused = 'paused';
const String _valueScheduled = 'scheduled';
