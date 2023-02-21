import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/internal/logger.dart';
import 'package:moengage_geofence/moe_android_geofence.dart';

import 'moe_geofence_constants.dart';
import 'moe_ios_geofence.dart';

class MoEngageGeofence {
  late String appId;

  late MethodChannel channel = MethodChannel(channelName);
  late MoEiOSGeofence moEiOSGeofence;
  late MoEAndroidGeofence moEAndroidGeofence;

  String _tag = "${TAG}MoEngageGeofence";

  MoEngageGeofence(this.appId) {
    moEiOSGeofence = MoEiOSGeofence(channel);
    moEAndroidGeofence = MoEAndroidGeofence(channel);
  }

  /// Starts Geofence Monitoring
  void startGeofenceMonitoring() {
    Logger.v("$_tag Starting GeoFence Monitoring");
    if (Platform.isIOS) {
      moEiOSGeofence.startGeofenceMonitoring(appId);
    } else if (Platform.isAndroid) {
      moEAndroidGeofence.startGeofenceMonitoring(appId);
    }
  }

  /// Stops Geofence Monitoring
  void stopGeofenceMonitoring() {
    Logger.v("$_tag Stopping GeoFence Monitoring");
    if (Platform.isIOS) {
      moEiOSGeofence.stopGeofenceMonitoring(appId);
    } else if (Platform.isAndroid) {
      moEAndroidGeofence.stopGeofenceMonitoring(appId);
    }
  }
}
