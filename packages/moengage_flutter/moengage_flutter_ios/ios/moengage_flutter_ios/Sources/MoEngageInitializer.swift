//
//  MoEngageInitializer.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 11/12/19.
//

import Foundation
import UserNotifications
import MoEngagePluginBase
import MoEngageSDK

@objc public class MoEngageInitializer : NSObject {
    
    @objc static public let sharedInstance = MoEngageInitializer()
    private override init() {super.init()}

    func getCoreVersion() -> String {
        guard
            let path = Bundle.main.url(
                forResource: "config", withExtension: "json",
                subdirectory: "Frameworks/App.framework/flutter_assets/packages/moengage_flutter"
            ),
            let data = try? Data(contentsOf: path),
            let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let version = obj["version"] as? String
        else { return "" }
        return version
    }

    @available(*, deprecated, message: "use 'initializeDefaultInstance(config:sdkState:launchOptions:)'")
    @objc public func initializeDefaultInstance(_ config: MoEngageSDKConfig, sdkState: Bool = true, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let currentSDKState: MoEngageSDKState = sdkState ? .enabled: .disabled
        initializeDefaultInstance(config: config, sdkState: currentSDKState, launchOptions: launchOptions)
    }
    
    @objc public func initializeDefaultInstance(config: MoEngageSDKConfig, sdkState: MoEngageSDKState = .enabled, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, sdkState: sdkState, launchOptions: launchOptions)
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: getCoreVersion())
    }
    
    @objc public func initializeDefaultInstance(_ config: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, launchOptions: launchOptions)
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: getCoreVersion())
    }

    @objc public func initializeInstance(_ config: MoEngageSDKInitializationConfig) {
        let plugin = MoEngagePlugin()
        plugin.initializeInstance(withConfig: config)
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: getCoreVersion())
    }

    @objc public func initializeDefaultInstance(withAdditionalConfig config: MoEngageSDKDefaultInitializationConfig = MoEngageSDKDefaultInitializationConfig()) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(withAdditionalConfig: config)
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: getCoreVersion())
    }
}
