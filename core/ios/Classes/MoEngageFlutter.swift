//
//  MoEngageFlutter.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 11/12/19.
//

import Foundation
import UserNotifications
import MoEngagePluginBase
import MoEngageSDK

@objc public class MoEngageFlutter : NSObject {
    
    @objc static public let sharedInstance = MoEngageFlutter()
    private override init() {super.init()}

    @objc public func initializeDefaultInstance(_ config: MOSDKConfig, sdkState: Bool = true, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, sdkState: sdkState, launchOptions: launchOptions)
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: MoEngageFlutterPluginInfo.kVersion)
    }
    
    @objc public func initializeDefaultInstance(_ config: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, launchOptions: launchOptions)
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: MoEngageFlutterPluginInfo.kVersion)
    }
}
