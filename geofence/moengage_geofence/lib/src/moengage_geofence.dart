import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'package:moengage_geofence_platform_interface/moengage_geofence_platform_interface.dart';

/// Helper Class to interact with MoEngage GeoFence Feature
class MoEngageGeofence {
  /// Constructor for [MoEngageGeofence]
  MoEngageGeofence(this.appId);

  /// MoEngage App ID
  late String appId;

  final String _tag = '${moduleTagGeofence}MoEngageGeofence';

  /// Starts Geofence Monitoring
  void startGeofenceMonitoring() {
    Logger.v('$_tag Starting GeoFence Monitoring');
    MoEngageGeofencePlatform.instance.startGeofenceMonitoring(appId);
  }

  /// Stops Geofence Monitoring
  void stopGeofenceMonitoring() {
    Logger.v('$_tag Stopping GeoFence Monitoring');
    MoEngageGeofencePlatform.instance.stopGeofenceMonitoring(appId);
  }
}
