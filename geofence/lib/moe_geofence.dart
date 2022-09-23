import 'dart:io';
import 'package:flutter/services.dart';
import 'moe_geofence_constants.dart';
import 'moe_ios_geofence.dart';

class MoEngageGeofence {
  late String appId;

  late MethodChannel channel = MethodChannel(channelName);
  late MoEiOSGeofence moEiOSGeofence;

  MoEngageGeofence(this.appId) {
    moEiOSGeofence = MoEiOSGeofence(channel);
  }

  void startGeofenceMonitoring() {
    if (Platform.isIOS) {
      moEiOSGeofence.startGeofenceMonitoring(appId);
    }
  }
}
