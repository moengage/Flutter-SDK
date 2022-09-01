
import 'moengage_geofence_platform_interface.dart';

class MoengageGeofence {
  Future<String?> getPlatformVersion() {
    return MoengageGeofencePlatform.instance.getPlatformVersion();
  }
}
