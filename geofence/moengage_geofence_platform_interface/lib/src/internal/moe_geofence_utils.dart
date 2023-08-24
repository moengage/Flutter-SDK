import 'moe_geofence_constants.dart';

/// Get Account Meta [Map]
Map<String, dynamic> getAccountMeta(String appId) {
  return {
    keyAccountMeta: {keyAppId: appId}
  };
}
