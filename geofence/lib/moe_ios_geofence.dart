import 'package:flutter/services.dart';
import 'moe_geofence_constants.dart';
import 'moe_geofence_utils.dart';

class MoEiOSGeofence {
  String _tag = "${TAG}InAppPayloadMapper";
  MethodChannel _channel;

  MoEiOSGeofence(this._channel);

  void startGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
          methodStartGeofenceMontioring, getAccountMeta(appId));
    } catch (e) {
      print("$_tag Error: startGeofenceMonitoring() : $e");
    }
  }
}
