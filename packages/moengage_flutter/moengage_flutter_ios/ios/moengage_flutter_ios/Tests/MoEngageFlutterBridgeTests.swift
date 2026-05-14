import Testing
import MoEngagePluginBase
@testable import moengage_flutter_ios

@Suite
struct MoEngageFlutterBridgeTests {
    let bridge = MoEngageFlutterBridge()

    @Test func pushTokenGeneratedMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.pushTokenGenerated) == "onPushTokenGenerated")
    }

    @Test func pushClickedMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.pushClicked) == "onPushClick")
    }

    @Test func inAppShownMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.inAppShown) == "onInAppShown")
    }

    @Test func inAppClickedMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.inAppClicked) == "onInAppClick")
    }

    @Test func inAppCustomActionMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.inAppCustomAction) == "onInAppCustomAction")
    }

    @Test func inAppDismissedMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.inAppDismissed) == "onInAppDismiss")
    }

    @Test func inAppSelfHandledMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.inAppSelfHandled) == "onInAppSelfHandle")
    }

    @Test func logoutCompleteMapping() {
        #expect(bridge.getCallbackName(forEventName: MoEngagePluginConstants.CallBackEvents.logOutCompleted) == "onLogoutComplete")
    }

    @Test func unknownEventReturnsNil() {
        #expect(bridge.getCallbackName(forEventName: "unknownEvent") == nil)
    }
}
