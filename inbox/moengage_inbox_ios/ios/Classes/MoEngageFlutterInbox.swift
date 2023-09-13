import Flutter
import UIKit
import MoEngagePluginBase
import MoEngagePluginInbox

public class MoEngageFlutterInbox: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MoEngageFlutterInboxConstants.kPluginChannelName, binaryMessenger: registrar.messenger())
        let instance = MoEngageFlutterInbox()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else{ return }
        
        switch call.method {
        case MoEngageFlutterInboxConstants.MethodNames.kFetchMessages:
            MoEngagePluginInboxBridge.sharedInstance.getInboxMessages(payload) { messagesPayload in
                DispatchQueue.main.async {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: messagesPayload),
                     let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                        result(jsonString)
                        return
                    }
                }
            }
            
        case MoEngageFlutterInboxConstants.MethodNames.kGetUnclickedCount:
            MoEngagePluginInboxBridge.sharedInstance.getUnreadMessageCount(payload) { unreadCountPayload in
                DispatchQueue.main.async {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: unreadCountPayload),
                    let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                        result(jsonString)
                        return
                    }
                }
            }
            
        case MoEngageFlutterInboxConstants.MethodNames.kTrackMessageClicked:
            MoEngagePluginInboxBridge.sharedInstance.trackInboxClick(payload)
            
        case MoEngageFlutterInboxConstants.MethodNames.kDeleteMessage:
            MoEngagePluginInboxBridge.sharedInstance.deleteInboxEntry(payload)
            
        default:
            print("Invalid invocation: \(call.method)")
        }
    }
}
