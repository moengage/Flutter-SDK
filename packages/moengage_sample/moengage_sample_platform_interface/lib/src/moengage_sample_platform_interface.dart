import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_moengage_sample.dart';

/// Platform Interface for the MoEngage Sample module.
abstract class MoEngageSamplePlatform extends PlatformInterface {
  /// Constructs a MoEngageSamplePlatform.
  MoEngageSamplePlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngageSamplePlatform _instance = MethodChannelMoEngageSample();

  /// The default instance of [MoEngageSamplePlatform] to use.
  ///
  /// Defaults to [MethodChannelMoEngageSample].
  static MoEngageSamplePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MoEngageSamplePlatform] when they register themselves.
  static set instance(MoEngageSamplePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Returns a sample greeting for the given [appId], round-tripped through
  /// the native Android/iOS implementation.
  Future<String> greet(String appId);
}
