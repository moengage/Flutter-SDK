import 'package:flutter/services.dart';
import 'moe_geofence_constants.dart';
import 'moe_geofence_utils.dart';

class MoEiOSGeofence {
  MethodChannel _channel;
  MoEiOSGeofence(this._channel);

  void startGeofenceMonitoring(String appId) {
    _channel.invokeMethod(methodStartGeofenceMontioring, getAccountMeta(appId));
  }
}
