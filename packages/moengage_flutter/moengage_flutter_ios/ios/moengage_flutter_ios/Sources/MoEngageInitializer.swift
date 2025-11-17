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

    /// Initializes the default MoEngage instance with configuration from Info.plist.
    ///
    /// This method enables SDK initialization using configuration values defined in the app's Info.plist file
    /// under the `MoEngage` dictionary key. The Info.plist should contain SDK configuration such as:
    /// - WorkspaceId: Your MoEngage workspace/app ID (required)
    /// - DataCenter: The data center region (default: 1)
    /// - IsSdkAutoInitialisationDisabled: Whether to disable auto-initialization (default: false)
    /// - IsTestEnvironment: Whether running in test mode
    /// - AppGroupName: App group name for sharing SDK data
    /// - KeychainGroupName: Keychain group name for storing encryption keys
    ///
    /// - Parameter config: Additional configuration options that can override or supplement Info.plist settings.
    ///   Defaults to a new instance of `MoEngageSDKDefaultInitializationConfig` if not provided.
    @objc public func initializeDefaultInstance(withAdditionalConfig config: MoEngageSDKDefaultInitializationConfig = MoEngageSDKDefaultInitializationConfig()) {
        let plugin = MoEngagePlugin()
        plugin.initializeDefaultInstance(withAdditionalConfig: config)
        plugin.trackPluginInfo(MoEngageFlutterConstants.kPluginName, version: getCoreVersion())
    }
}
