#import "MoEngageFlutterPlugin.h"
#import <moengage_flutter_ios/moengage_flutter_ios-Swift.h>

@implementation MoEngageFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [MoEngageFlutterBridge registerWithRegistrar:registrar];
}
@end
