import 'package:flutter/services.dart';
import 'moe_geofence_constants.dart';
import 'moe_geofence_utils.dart';
import 'package:moengage_flutter/internal/logger.dart';

class MoEiOSGeofence {
  String _tag = "${TAG}"+"MoEiOSGeofence";
  MethodChannel _channel;

  MoEiOSGeofence(this._channel);

  void startGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
          methodStartGeofenceMontioring, getAccountMeta(appId));
    } catch (e,stacktrace) {
      Logger.e("$_tag Error: startGeofenceMonitoring() : ",error: e,stackTrace: stacktrace);
    }
  }
}
