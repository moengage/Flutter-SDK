import Flutter
import UIKit
import MoEngagePluginBase
import MoEngageCore

public class MoEngageFlutterBridge: NSObject, FlutterPlugin {
    
    private static var channel : FlutterMethodChannel? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: MoEngageFlutterConstants.kPluginChannelName, binaryMessenger: registrar.messenger())
        let instance = MoEngageFlutterBridge()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    // MARK:- Handle Invocation
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case MoEngageFlutterConstants.MethodNames.kRegisterForPush:
            MoEngagePluginBridge.sharedInstance.registerForPush()
        case MoEngageFlutterConstants.MethodNames.kRegisterForProvisionalPush:
            registerForProvisionalPush()
        // Both dismisses are sent with no arguments, so they have to be handled before
        // `handleWithPayload`, which drops any call whose arguments aren't a map.
        //
        // Dart doesn't say which single-element overlay is showing - it has one dismiss for
        // all of them - so every renderer is asked. Each is a no-op when it isn't the one on
        // screen.
        case MoEngageFlutterConstants.MethodNames.kDismissElementTooltip:
            MoEngageFlutterSpotlightRenderer.dismiss()
            MoEngageFlutterTooltipRenderer.dismiss()
            MoEngageFlutterBeaconRenderer.dismiss()
        // Coach marks live in their own overlay window, so Dart dismisses them separately.
        case MoEngageFlutterConstants.MethodNames.kDismissElementCoachMarks:
            MoEngageFlutterCoachMarkRenderer.dismiss()
        default:
            handleWithPayload(call: call, result: result)
        }
    }
    
    private func handleWithPayload(call: FlutterMethodCall,  result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else { return }
        switch call.method {
        case MoEngageFlutterConstants.MethodNames.kInitializeFlutter:
            pluginInitialized(payload: payload)
            
        case MoEngageFlutterConstants.MethodNames.kShowInApp:
            MoEngagePluginBridge.sharedInstance.showInApp(payload)
        case MoEngageFlutterConstants.MethodNames.kGetSelfHandledInApp:
            MoEngagePluginBridge.sharedInstance.getSelfHandledInApp(payload)
        case MoEngageFlutterConstants.MethodNames.kUpdateSelfHandledInAppState:
            MoEngagePluginBridge.sharedInstance.updateSelfHandledImpression(payload)
        case MoEngageFlutterConstants.MethodNames.kSetAppContext:
            MoEngagePluginBridge.sharedInstance.setInAppContext(payload)
        case MoEngageFlutterConstants.MethodNames.kInvalidateAppContext:
            MoEngagePluginBridge.sharedInstance.resetInAppContext(payload)
        case MoEngageFlutterConstants.MethodNames.kShowNudge:
            MoEngagePluginBridge.sharedInstance.showNudge(payload)

        // Element-anchored overlays: Dart sends the resolved widget bounds, since native
        // cannot locate a Flutter widget by itself.
        case MoEngageFlutterConstants.MethodNames.kShowElementTooltip:
            showElementOverlay(payload: payload)
        // Dart re-reports the anchor's bounds as it scrolls; native can't track a
        // Flutter widget on its own.
        case MoEngageFlutterConstants.MethodNames.kUpdateElementTooltipAnchor:
            updateElementOverlayAnchor(payload: payload)
        // Several elements highlighted on one overlay, so this carries a list of steps
        // rather than a single anchor.
        case MoEngageFlutterConstants.MethodNames.kShowElementCoachMarks:
            MoEngageFlutterCoachMarkRenderer.show(payload: payload)

        case MoEngageFlutterConstants.MethodNames.kSetAppStatus:
            MoEngagePluginBridge.sharedInstance.setAppStatus(payload)
        case MoEngageFlutterConstants.MethodNames.kOptOutTracking:
            MoEngagePluginBridge.sharedInstance.optOutDataTracking(payload)
        case MoEngageFlutterConstants.MethodNames.kUpdateSDKState:
            MoEngagePluginBridge.sharedInstance.updateSDKState(payload)
        case MoEngageFlutterConstants.MethodNames.kTrackEvent:
            MoEngagePluginBridge.sharedInstance.trackEvent(payload)
        case MoEngageFlutterConstants.MethodNames.kSetUserAttribute:
            MoEngagePluginBridge.sharedInstance.setUserAttribute(payload)
        case MoEngageFlutterConstants.MethodNames.kSetAlias:
            MoEngagePluginBridge.sharedInstance.setAlias(payload)
        case MoEngageFlutterConstants.MethodNames.kResetUser:
            MoEngagePluginBridge.sharedInstance.resetUser(payload)
        case MoEngageFlutterConstants.MethodNames.kGetSelfHandleInApps:
            MoEngagePluginBridge.sharedInstance.getSelfHandledInApps(payload) { campaignPayload in
                MoEngageFlutterUtil.resume(channel: call.method, havingResult: result, withData: campaignPayload)
            }
        // Identities
        case MoEngageFlutterConstants.MethodNames.kIdentifyUser:
            MoEngagePluginBridge.sharedInstance.identifyUser(payload)
        case MoEngageFlutterConstants.MethodNames.kGetUserIdentities:
            MoEngagePluginBridge.sharedInstance.getUserIdentities(payload) { identitiesPayload in
                MoEngageFlutterUtil.resume(channel: call.method, havingResult: result, withData: identitiesPayload)
            }
        default:
            print("Invalid invocation: \(call.method)")
        }
    }

    func getCoreVersion() -> String {
        guard
            let path = Bundle.main.url(
                forResource: "config", withExtension: "json",
                subdirectory: "Frameworks/App.framework/flutter_assets/packages/moengage_flutter"
            ),
            let data = try? Data(contentsOf: path),
            let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let version = obj["version"] as? String
        else { return "" }
        return version
    }

    private func pluginInitialized(payload: [String: Any]){
        MoEngagePluginBridge.sharedInstance.setPluginBridgeDelegate(self, payload: payload)
        MoEngagePluginBridge.sharedInstance.pluginInitialized(payload)
        let plugin = MoEngagePlugin()
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: getCoreVersion())
    }
    
    /// Dispatches a `showElementTooltip` payload to the renderer for its `overlayType`.
    ///
    /// The beacon renders as a dot on both platforms - see `MoEngageFlutterBeaconRenderer` for
    /// how that is configured on iOS, where the dot can additionally expand into a card if the
    /// user taps it.
    private func showElementOverlay(payload: [String: Any]) {
        let overlayType = payload[MoEngageFlutterConstants.ElementTooltipKeys.kOverlayType] as? String
            ?? MoEngageFlutterConstants.ElementOverlayType.kTooltip
        switch overlayType {
        case MoEngageFlutterConstants.ElementOverlayType.kSpotlight:
            MoEngageFlutterSpotlightRenderer.show(payload: payload)
        case MoEngageFlutterConstants.ElementOverlayType.kBeacon:
            MoEngageFlutterBeaconRenderer.show(payload: payload)
        case MoEngageFlutterConstants.ElementOverlayType.kTooltip:
            MoEngageFlutterTooltipRenderer.show(payload: payload)
        default:
            MoEngageLogger.logDefault(logLevel: .warning,
                                      message: "Flutter - Element overlay: \"\(overlayType)\" is not a single-element overlay. Campaign not shown.")
        }
    }

    /// Routes an anchor update to the overlay that is actually showing.
    ///
    /// The tooltip and the beacon are separate native views with separate re-anchor calls, so
    /// the payload carries the overlay type. The spotlight and coach mark never reach here -
    /// Dart doesn't track them for following, since native has no API to move either.
    private func updateElementOverlayAnchor(payload: [String: Any]) {
        let overlayType = payload[MoEngageFlutterConstants.ElementTooltipKeys.kOverlayType] as? String
            ?? MoEngageFlutterConstants.ElementOverlayType.kTooltip
        switch overlayType {
        case MoEngageFlutterConstants.ElementOverlayType.kBeacon:
            MoEngageFlutterBeaconRenderer.updateAnchor(payload: payload)
        default:
            MoEngageFlutterTooltipRenderer.updateAnchor(payload: payload)
        }
    }

    private func registerForProvisionalPush() {
        if #available(iOS 12.0, *) {
            MoEngagePluginBridge.sharedInstance.registerForProvisionalPush()
        } else {
            MoEngageLogger.logDefault(message: "Register for Provisional Push is not supported below iOS 12")
        }
    }
    
}


extension MoEngageFlutterBridge: MoEngagePluginBridgeDelegate{
    public func sendMessage(event: String, message: [String : Any]) {
        if let callbackName = getCallbackName(forEventName: event) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: message)
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue){
                    MoEngageFlutterBridge.sendCallback(callbackName, withInfo: jsonString)
                    return
                }
                MoEngageFlutterBridge.sendCallback(callbackName, withInfo: "{}")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Utils
    func getCallbackName(forEventName name: String) -> String? {
        switch name {
        case MoEngagePluginConstants.CallBackEvents.pushTokenGenerated:
            return MoEngageFlutterConstants.CallbackNames.kPushTokenGenerated
        case MoEngagePluginConstants.CallBackEvents.pushClicked:
            return MoEngageFlutterConstants.CallbackNames.kPushClicked
        case MoEngagePluginConstants.CallBackEvents.inAppShown:
            return MoEngageFlutterConstants.CallbackNames.kInAppShown
        case MoEngagePluginConstants.CallBackEvents.inAppClicked:
            return MoEngageFlutterConstants.CallbackNames.kInAppClicked
        case MoEngagePluginConstants.CallBackEvents.inAppCustomAction:
            return MoEngageFlutterConstants.CallbackNames.kInAppClickedCustomAction
        case MoEngagePluginConstants.CallBackEvents.inAppDismissed:
            return MoEngageFlutterConstants.CallbackNames.kInAppDismissed
        case MoEngagePluginConstants.CallBackEvents.inAppSelfHandled:
            return MoEngageFlutterConstants.CallbackNames.kInAppSelfHandled
        case MoEngagePluginConstants.CallBackEvents.logOutCompleted:
            return MoEngageFlutterConstants.CallbackNames.kLogoutComplete
        default:
            return nil
        }
    }
    
    // MARK: Send Callback to Flutter
    internal static func sendCallback(_ callbackName: String, withInfo info: NSString) {
        DispatchQueue.main.async {
            channel?.invokeMethod(callbackName, arguments: info)
        }
    }
}
