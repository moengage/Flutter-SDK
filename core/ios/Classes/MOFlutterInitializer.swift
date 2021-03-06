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
    
    public func initializeWithSDKConfig(_ config: MOSDKConfig, andLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.initializeWithSDKConfig(config, withSDKState: MoEngageCore.sharedInstance().isSDKEnabled(), andLaunchOptions: launchOptions)
    }
    
    public func initializeWithSDKConfig(_ config: MOSDKConfig, withSDKState state:Bool, andLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Track Integration type
        MoEPluginBridge.sharedInstance()?.trackPluginVersion(MOFlutterPluginInfo.kVersion, for: Flutter)
        
        // Initialize SDK
        MoEPluginInitializer.sharedInstance().intializeSDK(with: config, withSDKState: state, andLaunchOptions: launchOptions ?? [:])
    }
    
}
