import Flutter
import UIKit
import MoEPluginBase
import MoEPluginInbox

public class SwiftMoEngageInboxPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MOFlutterInboxConstants.kPluginChannelName, binaryMessenger: registrar.messenger())
        let instance = SwiftMoEngageInboxPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any]
        else{
            print("Payload missing for the call \(call.method)")
            return
        }
        
        switch call.method {
        case MOFlutterInboxConstants.MethodNames.kFetchMessages:
            MoEInboxBridge.sharedInstance.getInboxMessages(payload) { messagesPayload in
                DispatchQueue.main.async {
                    result(messagesPayload)
                    return
                }
            }
        case MOFlutterInboxConstants.MethodNames.kGetUnclickedCount:
            MoEInboxBridge.sharedInstance.getUnreadMessageCount(payload) { unreadCountPayload in
                DispatchQueue.main.async {
                    result(unreadCountPayload)
                    return
                }
            }
            
        case MOFlutterInboxConstants.MethodNames.kTrackMessageClicked:
            MoEInboxBridge.sharedInstance.trackInboxClick(payload)
        case MOFlutterInboxConstants.MethodNames.kDeleteMessage:
            MoEInboxBridge.sharedInstance.deleteInboxEntry(payload)
        default:
            print("Invalid invocation: \(call.method)")
        }
    }
}
