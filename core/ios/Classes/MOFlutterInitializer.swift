//
//  MOFlutterInitializer.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 11/12/19.
//

import Foundation
import MoEngage
import UserNotifications
import MoEPluginBase

public class MOFlutterInitializer : NSObject {
    
    static public let sharedInstance = MOFlutterInitializer()
    private override init() {super.init()}
    
    public func initializeWithAppID(_ appID: String, withLaunchOptions options: [UIApplication.LaunchOptionsKey: Any]?) {
        // Track Integration type
        MoEPluginBridge.sharedInstance()?.trackPluginVersion(MOFlutterPluginInfo.kVersion, for: Flutter)
        
        // Initialize SDK
        MoEPluginInitializer.sharedInstance().intializeSDK(withAppID: appID, andLaunchOptions: options ?? [:])
    }
    
}
