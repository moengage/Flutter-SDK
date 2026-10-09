/// Scope a user attribute lives at - the calling project's own copy, or the portfolio-wide one.
///
/// In a portfolio workspace one attribute name can hold a value at both levels at once, so the
/// caller states the scope rather than the SDK inferring it.
enum UserAttributeLevel {
  /// The calling project's own copy of the attribute. The default level.
  project('project'),

  /// The portfolio-wide copy of the attribute, shared across projects.
  portfolio('portfolio');

  const UserAttributeLevel(this.value);

  /// JSON string representation of this level, as sent to/from the native platform.
  final String value;

  /// Get a [UserAttributeLevel] from its JSON string value, defaulting to [project] when [str]
  /// matches no known level - mirrors the contract's own fallback.
  static UserAttributeLevel fromString(String str) {
    for (final level in UserAttributeLevel.values) {
      if (level.value == str) {
        return level;
      }
    }
    return UserAttributeLevel.project;
  }
}
