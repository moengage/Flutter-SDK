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
            MoEPluginBridge.sharedInstance()?.pluginInitialized()
        case MOFlutterConstants.MethodNames.kRegisterForPush:
            MoEPluginBridge.sharedInstance()?.registerForPush()
        case MOFlutterConstants.MethodNames.kShowInApp:
            MoEPluginBridge.sharedInstance()?.showInApp()
        case MOFlutterConstants.MethodNames.kGetSelfHandledInApp:
            MoEPluginBridge.sharedInstance()?.getSelfHandledInApp()
        case MOFlutterConstants.MethodNames.kInvalidateAppContext:
            MoEPluginBridge.sharedInstance()?.invalidateInAppContexts()
        case MOFlutterConstants.MethodNames.kEnableLogs:
            MoEPluginBridge.sharedInstance()?.enableLogs()
        case MOFlutterConstants.MethodNames.kResetUser:
            MoEPluginBridge.sharedInstance()?.resetUser()
        default:
            handleBridgeMethodWithPayload(forMethodCall: call)
        }
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
            default:
                print("Invalid invocation: \(call.method)")
            }
            MoEPluginBridge.sharedInstance()?.setAppStatus(payload)
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
            MOFlutterPlugin.sendCallback(callbackName, withInfo: payloadDict)
        }
    }
    
    // MARK: Utils
    func getCallbackName(forEventName name: String) -> String?{
        switch name {
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
    internal static func sendCallback(_ callbackName: String, withInfo infoDict: [AnyHashable : Any]){
        channel?.invokeMethod(callbackName, arguments: infoDict)
    }
}
