#import "MOFlutterRegistrant.h"
#import <moengage_flutter/moengage_flutter-Swift.h>

@implementation MOFlutterRegistrant
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [MOFlutterPlugin registerWithRegistrar:registrar];
}
@end
