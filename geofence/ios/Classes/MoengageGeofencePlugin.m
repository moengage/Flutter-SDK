#import "MoengageGeofencePlugin.h"
#if __has_include(<moengage_geofence/moengage_geofence-Swift.h>)
#import <moengage_geofence/moengage_geofence-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "moengage_geofence-Swift.h"
#endif

@implementation MoEngageGeofencePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [MoEFlutterGeofence registerWithRegistrar:registrar];
}
@end
