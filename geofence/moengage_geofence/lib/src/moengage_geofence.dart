import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'package:moengage_geofence_platform_interface/moengage_geofence_platform_interface.dart';

class MoEngageGeofence {
  MoEngageGeofence(this.appId);
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
