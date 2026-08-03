/// Error returned by the Personalize API.
class PersonalizeError implements Exception {
  /// [PersonalizeError] Constructor
  PersonalizeError({
    required this.code,
    required this.message,
  });

  /// Error code string (e.g., SDK_NOT_INITIALIZED, NETWORK_ERROR).
  final String code;

  /// Human-readable error message.
  final String message;

  @override
  String toString() {
    return 'PersonalizeError{code: $code, message: $message}';
  }
}
