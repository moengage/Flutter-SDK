import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger;
import 'package:moengage_geofence_platform_interface/moengage_geofence_platform_interface.dart';

/// The Android implementation of [MoEngageGeofencePlatform].
class MoEngageGeofenceAndroid extends MoEngageGeofencePlatform {
  final String _tag = '${moduleTagGeofence}MoEAndroidGeofence';

  final MethodChannel _channel = const MethodChannel(geoFenceChannelName);

  /// Registers this class as the default instance of [MoEngageGeofencePlatform]
  static void registerWith() {
    Logger.v('Registering MoEngageGeofenceAndroid with Platform Interface');
    MoEngageGeofencePlatform.instance = MoEngageGeofenceAndroid();
  }

  @override
  void startGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
          methodStartGeofenceMonitoring, getAccountMeta(appId));
    } catch (e) {
      Logger.e('$_tag Error: startGeofenceMonitoring() : $e');
    }
  }

  @override
  void stopGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
          methodStopGeofenceMonitoring, getAccountMeta(appId));
    } catch (e) {
      Logger.e('$_tag Error: stopGeofenceMonitoring() : $e');
    }
  }
}
