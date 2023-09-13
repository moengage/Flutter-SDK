import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show Logger, getAccountMeta;
import 'package:moengage_geofence_platform_interface/moengage_geofence_platform_interface.dart';

/// IOS implementation of [MoEngageGeofencePlatform].
class MoEngageGeofenceIOS extends MoEngageGeofencePlatform {
  /// [MoEngageGeofenceIOS] Constructor
  MoEngageGeofenceIOS();

  final String _tag = '${moduleTagGeofence}MoEngageGeofenceIOS';

  final MethodChannel _channel = const MethodChannel(geoFenceChannelName);

  /// Registers this class as the default instance of [MoEngageGeofencePlatform]
  static void registerWith() {
    Logger.v('Registering MoEngageGeofenceIOS with Platform Interface');
    MoEngageGeofencePlatform.instance = MoEngageGeofenceIOS();
  }

  @override
  void startGeofenceMonitoring(String appId) {
    try {
      _channel.invokeMethod(
        methodStartGeofenceMonitoring,
        getAccountMeta(appId),
      );
    } catch (e, stacktrace) {
      Logger.e(
        '$_tag Error: startGeofenceMonitoring() : ',
        error: e,
        stackTrace: stacktrace,
      );
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
