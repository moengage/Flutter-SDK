#import "MoEngageInboxPlugin.h"
#if __has_include(<moengage_inbox/moengage_inbox-Swift.h>)
#import <moengage_inbox/moengage_inbox-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "moengage_inbox-Swift.h"
#endif

@implementation MoEngageInboxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftMoEngageInboxPlugin registerWithRegistrar:registrar];
}
@end
