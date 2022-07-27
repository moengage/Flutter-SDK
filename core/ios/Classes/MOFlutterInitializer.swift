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

@objc public class MOFlutterInitializer : NSObject {
    
    @objc static public let sharedInstance = MOFlutterInitializer()
    private override init() {super.init()}
    
    @objc public func initializeWithSDKConfig(_ config: MOSDKConfig, andLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.initializeWithSDKConfig(config, withSDKState: MoEngageCore.sharedInstance().isSDKEnabled(), andLaunchOptions: launchOptions)
    }
    
    @objc public func initializeWithSDKConfig(_ config: MOSDKConfig, withSDKState state:Bool, andLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Track Integration type and version
        config.pluginIntegrationType = FLUTTER
        config.pluginIntegrationVersion = MOFlutterPluginInfo.kVersion
        
        // Initialize SDK
        MoEPluginInitializer.sharedInstance().intializeSDK(with: config, withSDKState: state, andLaunchOptions: launchOptions ?? [:])
    }
    
}
