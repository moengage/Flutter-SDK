import 'package:flutter/services.dart';
import 'moe_geofence_constants.dart';
import 'moe_geofence_utils.dart';

class MoEiOSGeofence {
  String _tag = "${TAG}MoEiOSGeofence";
  MethodChannel _channel;

  MoEiOSGeofence(this._channel);

  void startGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
          methodStartGeofenceMonitoring, getAccountMeta(appId));
    } catch (e) {
      print("$_tag Error: startGeofenceMonitoring() : $e");
    }
  }

  void stopGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
          methodStopGeofenceMonitoring, getAccountMeta(appId));
    } catch (e) {
      print("$_tag Error: stopGeofenceMonitoring() : $e");
    }
  }
}
