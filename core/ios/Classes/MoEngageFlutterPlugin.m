#import "MoEngageFlutterPlugin.h"
#import <moengage_flutter/moengage_flutter-Swift.h>

@implementation MoEngageFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [MOFlutterPlugin registerWithRegistrar:registrar];
}
@end
