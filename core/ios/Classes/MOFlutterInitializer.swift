//
//  MOFlutterInitializer.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 11/12/19.
//

import Foundation
import UserNotifications
import MoEPluginBase
import MoEngageSDK

@objc public class MOFlutterInitializer : NSObject {
    
    @objc static public let sharedInstance = MOFlutterInitializer()
    private override init() {super.init()}

    @objc public func initializeDefaultInstance(_ config: MOSDKConfig, sdkState: Bool = true, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEPlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, sdkState: sdkState, launchOptions: launchOptions)
        plugin.trackPluginInfo(MOFlutterConstants.kPluginName, version: MOFlutterPluginInfo.kVersion)
    }
    
    @objc public func initializeDefaultInstance(_ config: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEPlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, launchOptions: launchOptions)
        plugin.trackPluginInfo(MOFlutterConstants.kPluginName, version: MOFlutterPluginInfo.kVersion)
    }
}
