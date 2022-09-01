import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_geofence/moengage_geofence.dart';
import 'package:moengage_geofence/moengage_geofence_platform_interface.dart';
import 'package:moengage_geofence/moengage_geofence_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoengageGeofencePlatform 
    with MockPlatformInterfaceMixin
    implements MoengageGeofencePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MoengageGeofencePlatform initialPlatform = MoengageGeofencePlatform.instance;

  test('$MethodChannelMoengageGeofence is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMoengageGeofence>());
  });

  test('getPlatformVersion', () async {
    MoengageGeofence moengageGeofencePlugin = MoengageGeofence();
    MockMoengageGeofencePlatform fakePlatform = MockMoengageGeofencePlatform();
    MoengageGeofencePlatform.instance = fakePlatform;
  
    expect(await moengageGeofencePlugin.getPlatformVersion(), '42');
  });
}
