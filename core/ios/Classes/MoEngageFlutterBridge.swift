import Flutter
import UIKit
import MoEngagePluginBase

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
        
        default:
            handleWithPayload(call: call)
        }
    }
    
    private func handleWithPayload(call: FlutterMethodCall) {
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
            
        default:
            print("Invalid invocation: \(call.method)")
        }
    }
    private func pluginInitialized(payload: [String: Any]){
        MoEngagePluginBridge.sharedInstance.setPluginBridgeDelegate(self, payload: payload)
        MoEngagePluginBridge.sharedInstance.pluginInitialized(payload)
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
