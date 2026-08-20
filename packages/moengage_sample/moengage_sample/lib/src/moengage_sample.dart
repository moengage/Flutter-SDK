import 'package:moengage_sample_platform_interface/moengage_sample_platform_interface.dart';

/// Sample helper class demonstrating the shape of a MoEngage Flutter module.
///
/// This class is intentionally minimal - the module exists to validate the
/// CI and pub.dev release pipeline for newly added Flutter SDK modules, and
/// to serve as a federated-plugin scaffold to copy from when starting a new
/// module (app-facing package + Android + iOS + platform interface).
class MoEngageSample {
  /// [MoEngageSample] Constructor
  MoEngageSample(this.appId);

  /// AppId Available in MoEngage Platform
  late String appId;

  /// Returns a sample greeting for [appId], round-tripped through the
  /// native Android/iOS implementation via the platform interface.
  Future<String> greet() {
    return MoEngageSamplePlatform.instance.greet(appId);
  }
}
