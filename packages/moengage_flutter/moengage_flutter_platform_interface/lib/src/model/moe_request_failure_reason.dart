/// A reason a MoEngage SDK request failed.
///
/// Mirrors the native SDKs' `MoERequestFailureReason` marker interface: [CommonFailureReason]
/// implements it directly for the generic, cross-feature reasons, and each feature defines its own
/// enum implementing it for feature-specific reasons — composition instead of enum inheritance,
/// since Dart enums cannot extend one another.
abstract interface class MoERequestFailureReason {
  /// JSON string representation of this reason, as sent by the native platform.
  String get value;
}
