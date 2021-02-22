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
        case MOFlutterConstants.MethodNames.kInitializeFlutter:
            pluginInitialized()
        case MOFlutterConstants.MethodNames.kRegisterForPush:
            MoEPluginBridge.sharedInstance()?.registerForPush()
        case MOFlutterConstants.MethodNames.kShowInApp:
            MoEPluginBridge.sharedInstance()?.showInApp()
        case MOFlutterConstants.MethodNames.kGetSelfHandledInApp:
            MoEPluginBridge.sharedInstance()?.getSelfHandledInApp()
        case MOFlutterConstants.MethodNames.kInvalidateAppContext:
            MoEPluginBridge.sharedInstance()?.invalidateInAppContexts()
        case MOFlutterConstants.MethodNames.kStartGeofence:
            MoEPluginBridge.sharedInstance()?.startGeofenceMonitoring()
        case MOFlutterConstants.MethodNames.kEnableLogs:
            MoEPluginBridge.sharedInstance()?.enableLogs()
        case MOFlutterConstants.MethodNames.kResetUser:
            MoEPluginBridge.sharedInstance()?.resetUser()
        default:
            handleBridgeMethodWithPayload(forMethodCall: call)
        }
    }
    
    private func pluginInitialized(){
        MoEPluginBridge.sharedInstance()?.bridgeDelegate = self
        MoEPluginBridge.sharedInstance()?.pluginInitialized()
    }
    
    private func handleBridgeMethodWithPayload(forMethodCall call: FlutterMethodCall){
        if let payload = call.arguments as? [String: Any]{
            switch call.method {
            case MOFlutterConstants.MethodNames.kSetAppStatus:
                MoEPluginBridge.sharedInstance()?.setAppStatus(payload)
            case MOFlutterConstants.MethodNames.kTrackEvent:
                MoEPluginBridge.sharedInstance()?.trackEvent(withPayload: payload)
            case MOFlutterConstants.MethodNames.kSetUserAttribute:
                MoEPluginBridge.sharedInstance()?.setUserAttributeWithPayload(payload)
            case MOFlutterConstants.MethodNames.kSetAlias:
                MoEPluginBridge.sharedInstance()?.setAlias(payload)
            case MOFlutterConstants.MethodNames.kUpdateSelfHandledInAppState:
                MoEPluginBridge.sharedInstance()?.updateSelfHandledInAppStatus(withPayload: payload)
            case MOFlutterConstants.MethodNames.kSetAppContext:
                MoEPluginBridge.sharedInstance()?.setInAppContexts(payload)
            case MOFlutterConstants.MethodNames.kOptOutTracking:
                MoEPluginBridge.sharedInstance()?.optOutTracking(payload)
            case MOFlutterConstants.MethodNames.kUpdateSDKState:
                MoEPluginBridge.sharedInstance()?.updateSDKState(payload)
            default:
                print("Invalid invocation: \(call.method)")
            }
        }
        else{
            print("Payload not present for method: \(call.method)")
        }
    }
    
}


extension MOFlutterPlugin: MoEPluginBridgeDelegate{
    
    // MARK: MoEPluginBridgeDelegate Method
    public func sendMessage(withName name: String!, andPayload payloadDict: [AnyHashable : Any]!) {
        if let callbackName = getCallbackName(forEventName: name){
            if let payloadToSend = payloadDict["payload"] as? [AnyHashable : Any]{
                let jsonData = try! JSONSerialization.data(withJSONObject: payloadToSend)
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue){
                    MOFlutterPlugin.sendCallback(callbackName, withInfo: jsonString)
                    return
                }
            }
            MOFlutterPlugin.sendCallback(callbackName, withInfo: "{}")
        }
    }
    
    // MARK: Utils
    func getCallbackName(forEventName name: String) -> String?{
        switch name {
        case kEventNamePushTokenGenerated:
            return MOFlutterConstants.CallbackNames.kPushTokenGenerated
        case kEventNamePushClicked:
            return MOFlutterConstants.CallbackNames.kPushClicked
        case kEventNameInAppCampaignShown:
            return MOFlutterConstants.CallbackNames.kInAppShown
        case kEventNameInAppCampaignClicked:
            return MOFlutterConstants.CallbackNames.kInAppClicked
        case kEventNameInAppCampaignCustomAction:
            return MOFlutterConstants.CallbackNames.kInAppClickedCustomAction
        case kEventNameInAppCampaignDismissed:
            return MOFlutterConstants.CallbackNames.kInAppDismissed
        case kEventNameInAppSelfHandledCampaign:
            return MOFlutterConstants.CallbackNames.kInAppSelfHandled
        default:
            return nil
        }
    }
    
    // MARK: Send Callback to Flutter
    internal static func sendCallback(_ callbackName: String, withInfo info: NSString){
        DispatchQueue.main.async {
            channel?.invokeMethod(callbackName, arguments: info)
        }
    }
}
