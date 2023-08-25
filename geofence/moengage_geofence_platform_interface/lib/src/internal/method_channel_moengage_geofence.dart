import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger, getAccountMeta;
import '../../moengage_geofence_platform_interface.dart';

/// An implementation of [MoEngageGeofencePlatform] that uses method channels.
class MethodChannelMoEngageGeofence extends MoEngageGeofencePlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel(geoFenceChannelName);

  final String _tag = '${moduleTagGeofence}MoEAndroidGeofence';

  @override
  void startGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
        methodStartGeofenceMonitoring,
        getAccountMeta(appId),
      );
    } catch (e) {
      Logger.e('$_tag Error: startGeofenceMonitoring() : $e');
    }
  }

  @override
  void stopGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
        methodStopGeofenceMonitoring,
        getAccountMeta(appId),
      );
    } catch (e) {
      Logger.e('$_tag Error: stopGeofenceMonitoring() : $e');
    }
  }
}
