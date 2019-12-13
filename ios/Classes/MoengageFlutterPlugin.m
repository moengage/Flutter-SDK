#import "MoengageFlutterPlugin.h"
#import <moengage_flutter/moengage_flutter-Swift.h>

@implementation MoengageFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMoengageFlutterPlugin registerWithRegistrar:registrar];
}
@end
