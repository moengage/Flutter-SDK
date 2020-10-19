import Flutter
import UIKit
import MoEPluginBase

public class SwiftMoEngageInboxPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MOFlutterInboxConstants.kPluginChannelName, binaryMessenger: registrar.messenger())
        let instance = SwiftMoEngageInboxPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case MOFlutterInboxConstants.MethodNames.kFetchMessages:
            self.fetchAllMessages(withResult: result)
        case MOFlutterInboxConstants.MethodNames.kTrackMessageClicked:
            if let payload = call.arguments as? [String: Any]{
                MoEPluginBridge.sharedInstance()?.trackInboxClick(forCampaign: payload)
            }
        case MOFlutterInboxConstants.MethodNames.kDeleteMessage:
            if let payload = call.arguments as? [String: Any]{
                MoEPluginBridge.sharedInstance()?.deleteInboxEntry(forCampaign: payload)
            }
        case MOFlutterInboxConstants.MethodNames.kGetUnclickedCount:
            let unreadCount = MoEPluginBridge.sharedInstance().getUnreadMessageCount()
            // Switch to main thread
            DispatchQueue.main.async {
                result(unreadCount)
            }
        default:
            print("Invalid invocation: \(call.method)")
        }
    }
    
    private func fetchAllMessages(withResult result: @escaping FlutterResult){
        MoEPluginBridge.sharedInstance()?.getInboxMessages(completionBlock: { (messagesPayload) in
            // Switch to main thread
            DispatchQueue.main.async {
                if let messagesPayload = messagesPayload{
                    if let resultStr = MoEPluginUtils.jsonString(fromDict: messagesPayload){
                        result(resultStr)
                        return
                    }
                }
                result("")
            }
        })
    }
}
