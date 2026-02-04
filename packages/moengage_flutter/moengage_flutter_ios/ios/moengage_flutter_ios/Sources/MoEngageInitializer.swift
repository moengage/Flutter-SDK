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

    @available(*, deprecated, message: "use 'initializeDefaultInstance(config:sdkState:launchOptions:)'")
    @objc public func initializeDefaultInstance(_ config: MoEngageSDKConfig, sdkState: Bool = true, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let currentSDKState: MoEngageSDKState = sdkState ? .enabled: .disabled
        initializeDefaultInstance(config: config, sdkState: currentSDKState, launchOptions: launchOptions)
    }
    
    @objc public func initializeDefaultInstance(config: MoEngageSDKConfig, sdkState: MoEngageSDKState = .enabled, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, sdkState: sdkState, launchOptions: launchOptions)
    }
    
    @objc public func initializeDefaultInstance(_ config: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(sdkConfig: config, launchOptions: launchOptions)
    }

    @objc public func initializeInstance(_ config: MoEngageSDKInitializationConfig) {
        let plugin = MoEngagePlugin()
        plugin.initializeInstance(withConfig: config)
    }

    /// Initializes the default MoEngage instance with configuration from Info.plist.
    ///
    /// This method enables SDK initialization using configuration values defined in the app's Info.plist file
    /// under the `MoEngage` dictionary key.
    ///
    /// - Parameter config: Additional configuration options that can override or supplement Info.plist settings.
    ///   Defaults to a new instance of `MoEngageSDKDefaultInitializationConfig` if not provided.
    @objc public func initializeDefaultInstance(withAdditionalConfig config: MoEngageSDKDefaultInitializationConfig = MoEngageSDKDefaultInitializationConfig()) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(withAdditionalConfig: config)
    }
}
