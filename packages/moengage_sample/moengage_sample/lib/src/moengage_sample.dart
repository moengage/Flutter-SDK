/// Sample helper class demonstrating the shape of a MoEngage Flutter module.
///
/// This class is intentionally minimal - the module exists to validate the
/// CI and pub.dev release pipeline for newly added Flutter SDK modules, and
/// to serve as a scaffold to copy from when starting a new module.
class MoEngageSample {
  /// [MoEngageSample] Constructor
  MoEngageSample(this.appId);

  /// AppId Available in MoEngage Platform
  late String appId;

  /// Returns a sample greeting for the given [appId].
  String greet() {
    return 'Hello from MoEngage Sample module, appId: $appId';
  }
}
