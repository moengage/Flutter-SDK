import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moengage_geofence_method_channel.dart';

abstract class MoengageGeofencePlatform extends PlatformInterface {
  /// Constructs a MoengageGeofencePlatform.
  MoengageGeofencePlatform() : super(token: _token);

  static final Object _token = Object();

  static MoengageGeofencePlatform _instance = MethodChannelMoengageGeofence();

  /// The default instance of [MoengageGeofencePlatform] to use.
  ///
  /// Defaults to [MethodChannelMoengageGeofence].
  static MoengageGeofencePlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoengageGeofencePlatform] when
  /// they register themselves.
  static set instance(MoengageGeofencePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
