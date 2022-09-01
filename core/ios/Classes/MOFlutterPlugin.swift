import Flutter
import UIKit
import MoEPluginBase

public class MOFlutterPlugin: NSObject, FlutterPlugin {
    
    private static var channel : FlutterMethodChannel? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: MOFlutterConstants.kPluginChannelName, binaryMessenger: registrar.messenger())
        let instance = MOFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    // MARK:- Handle Invocation
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case MOFlutterConstants.MethodNames.kRegisterForPush:
            MoEPluginBridge.sharedInstance.registerForPush()
        
        default:
            handleWithPayload(call: call)
        }
    }
    
    private func handleWithPayload(call: FlutterMethodCall) {
        guard let payload = call.arguments as? [String: Any] else { return }
        switch call.method {
        case MOFlutterConstants.MethodNames.kInitializeFlutter:
            pluginInitialized(payload: payload)
            
        case MOFlutterConstants.MethodNames.kShowInApp:
            MoEPluginBridge.sharedInstance.showInApp(payload)
        case MOFlutterConstants.MethodNames.kGetSelfHandledInApp:
            MoEPluginBridge.sharedInstance.getSelfHandledInApp(payload)
        case MOFlutterConstants.MethodNames.kUpdateSelfHandledInAppState:
            MoEPluginBridge.sharedInstance.updateSelfHandledImpression(payload)
        case MOFlutterConstants.MethodNames.kSetAppContext:
            MoEPluginBridge.sharedInstance.setInAppContext(payload)
        case MOFlutterConstants.MethodNames.kInvalidateAppContext:
            MoEPluginBridge.sharedInstance.resetInAppContext(payload)


        case MOFlutterConstants.MethodNames.kSetAppStatus:
            MoEPluginBridge.sharedInstance.setAppStatus(payload)
        case MOFlutterConstants.MethodNames.kOptOutTracking:
            MoEPluginBridge.sharedInstance.optOutDataTracking(payload)
        case MOFlutterConstants.MethodNames.kUpdateSDKState:
            MoEPluginBridge.sharedInstance.updateSDKState(payload)
        case MOFlutterConstants.MethodNames.kTrackEvent:
            MoEPluginBridge.sharedInstance.trackEvent(payload)
        case MOFlutterConstants.MethodNames.kSetUserAttribute:
            MoEPluginBridge.sharedInstance.setUserAttribute(payload)
        case MOFlutterConstants.MethodNames.kSetAlias:
            MoEPluginBridge.sharedInstance.setAlias(payload)
        case MOFlutterConstants.MethodNames.kResetUser:
            MoEPluginBridge.sharedInstance.resetUser(payload)
            
        default:
            print("Invalid invocation: \(call.method)")
        }
    }
    private func pluginInitialized(payload: [String: Any]){
        MoEPluginBridge.sharedInstance.setPluginBridgeDelegate(self, payload: payload)
        MoEPluginBridge.sharedInstance.pluginInitialized(payload)
    }
}


extension MOFlutterPlugin: MoEPluginBridgeDelegate{
    public func sendMessage(event: String, message: [String : Any]) {
        if let callbackName = getCallbackName(forEventName: event) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: message)
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue){
                    MOFlutterPlugin.sendCallback(callbackName, withInfo: jsonString)
                    return
                }
                MOFlutterPlugin.sendCallback(callbackName, withInfo: "{}")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Utils
    func getCallbackName(forEventName name: String) -> String? {
        switch name {
        case MoEPluginConstants.CallBackEvents.pushTokenGenerated:
            return MOFlutterConstants.CallbackNames.kPushTokenGenerated
        case MoEPluginConstants.CallBackEvents.pushClicked:
            return MOFlutterConstants.CallbackNames.kPushClicked
        case MoEPluginConstants.CallBackEvents.inAppShown:
            return MOFlutterConstants.CallbackNames.kInAppShown
        case MoEPluginConstants.CallBackEvents.inAppClicked:
            return MOFlutterConstants.CallbackNames.kInAppClicked
        case MoEPluginConstants.CallBackEvents.inAppCustomAction:
            return MOFlutterConstants.CallbackNames.kInAppClickedCustomAction
        case MoEPluginConstants.CallBackEvents.inAppDismissed:
            return MOFlutterConstants.CallbackNames.kInAppDismissed
        case MoEPluginConstants.CallBackEvents.inAppSelfHandled:
            return MOFlutterConstants.CallbackNames.kInAppSelfHandled
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
