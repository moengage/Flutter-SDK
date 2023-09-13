import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'internal/method_channel_moengage_geofence.dart';

/// The interface that implementations of moengage_geofence must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `MoEngageGeofence`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [MoEngageGeofencePlatform] methods.
abstract class MoEngageGeofencePlatform extends PlatformInterface {
  /// Constructs a MoEngageGeofencePlatform.
  MoEngageGeofencePlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngageGeofencePlatform _instance = MethodChannelMoEngageGeofence();

  /// The default instance of [MoEngageGeofencePlatform] to use.
  ///
  /// Defaults to [MethodChannelMoEngageGeofence].
  static MoEngageGeofencePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MoEngageGeofencePlatform] when they register themselves.
  static set instance(MoEngageGeofencePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Starts Geofence Monitoring
  /// [appId] - MoEngage App ID
  void startGeofenceMonitoring(String appId);

  /// Stops Geofence Monitoring
  /// [appId] - MoEngage App ID
  void stopGeofenceMonitoring(String appId);
}
