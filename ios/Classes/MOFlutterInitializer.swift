//
//  MOFlutterInitializer.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 11/12/19.
//

import Foundation
import MoEngage
import UserNotifications

public class MOFlutterInitializer : NSObject, MOInAppDelegate, UNUserNotificationCenterDelegate {
    
    static public let sharedInstance = MOFlutterInitializer()
    private override init() {super.init()}
    
    public func initializeWithAppID(_ appID: String, withLaunchOptions options: [UIApplication.LaunchOptionsKey: Any]?) {
        
        if #available(iOS 10.0, *) {
            if UNUserNotificationCenter.current().delegate == nil {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        // Set Flutter SDK Version
        self.setSDKVersion()
        
        // SDK INITIALIZATION
        #if DEBUG
            MoEngage.sharedInstance().initializeDev(withApiKey: appID, in: UIApplication.shared, withLaunchOptions: options, openDeeplinkUrlAutomatically: true)
        #else
            MoEngage.sharedInstance().initializeProd(withApiKey: appID, in: UIApplication.shared, withLaunchOptions: options, openDeeplinkUrlAutomatically: true)
        #endif
        
        // Observer for Push Clicks
        self.addObserversForPushCallbacks()
        
        // Observer for InApp callbacks
        MoEngage.sharedInstance().delegate = self
    }
    
    func setSDKVersion() {
        var version = "1.0.0"
        let bundle = Bundle(for: type(of: self))
        if let versionStr = bundle.infoDictionary?["CFBundleShortVersionString"] as? String {
            version = versionStr
        }
        UserDefaults.standard.set(version, forKey:MoEngage_Flutter_SDK_Version)
    }
    
    //MARK:- Push Observer
    
    func addObserversForPushCallbacks(){
        NotificationCenter.default.addObserver(self, selector: #selector(clickedRemoteNotifications(_:)), name: NSNotification.Name.MoEngage_Notification_Received_, object: nil)
    }
    
    @objc func clickedRemoteNotifications(_ notif:Notification){
        if let userInfo = notif.userInfo as? Dictionary<String,Any>{
            let infoDict : Dictionary<String,Any> = ["payload": userInfo]
            MOFlutterPlugin.sendCallback(MOFlutterConstants.CallbackNames.kPushClicked, withInfo:infoDict);
        }
    }
    
    //MARK:- UNUserNotificationCenterDelegate methods
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response);
        completionHandler();
    }
    
    //MARK:- MOInAppDelegate Callbacks
    public func inAppShown(withCampaignID campaignID: String?) {
        if let campaignID = campaignID{
            var msgDict : Dictionary<String,Any> = Dictionary()
            msgDict["payload"] = ["campaignId":campaignID]
            
            MOFlutterPlugin.sendCallback(MOFlutterConstants.CallbackNames.kInAppShown, withInfo: msgDict);
        }
    }
    
    public func inAppClicked(for widget: InAppWidget, screenName: String?, andDataDict dataDict: [AnyHashable : Any]?) {
        var inAppDict : Dictionary<String,Any> = Dictionary()
        if let screenName = screenName{
            inAppDict["screenName"] = screenName
        }
        if let dataDict = dataDict as? Dictionary<String, Any>{
            inAppDict["kvPairs"] = dataDict
        }
        var msgDict : Dictionary<String,Any> = Dictionary()
        msgDict["payload"] = inAppDict
        MOFlutterPlugin.sendCallback(MOFlutterConstants.CallbackNames.kInAppClicked, withInfo: msgDict);
    }
    
}
