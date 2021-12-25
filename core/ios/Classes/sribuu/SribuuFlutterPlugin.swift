import Flutter
import UIKit
import MoEPluginBase
import MoEngage


public class SribuuFlutterPlugin: NSObject, FlutterPlugin {
    private static var sribuuChannel : FlutterMethodChannel? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        sribuuChannel = FlutterMethodChannel(name: SribuuFlutterConstants.sribuuChannelName, binaryMessenger: registrar.messenger())
        
        let instance = SribuuFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: sribuuChannel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == SribuuFlutterConstants.MethodNames.configureMoEngage) {
            configureMoEngage(call: call)
        }
    }
    
    private func configureMoEngage(call: FlutterMethodCall) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let appId = arguments["appId"] as! String
        let setupCalls = arguments["setupCalls"] as! Dictionary<String, Any>
        
        let initializerHelper: MoEngageInitializerHelper = MoEngageInitializerHelper(appId: appId, setupCalls: setupCalls)
        initializerHelper.initialize()
    }
}

class MoEngageInitializerHelper {
    var appId: String
    var setupCalls: Dictionary<String, Any>
    var sdkConfig: MOSDKConfig
    
    init(appId: String, setupCalls: Dictionary<String, Any>) {
        self.appId = appId
        self.setupCalls = setupCalls
        self.sdkConfig = MOSDKConfig.init(appID: appId)
    }
    
    public func initialize() {
        print(setupCalls)
        setAppGroupIdIfDeclared()
        setDataCenterIfDeclared()
        setAnalyticsDisablePeriodicFlushIfDeclared()
        setAnalyticsPeriodicFlushDurationIfDeclared()
        setEncryptNetworkRequestsIfDeclared()
        setOptOutDataTrackingIfDeclared()
        setOptOutPushNotificationIfDeclared()
        setOptOutInAppCampaignIfDeclared()
        setOptOutIDFATrackingIfDeclared()
        setOptOutIDFVTrackingIfDeclared()
        
        MOFlutterInitializer.sharedInstance.initializeWithSDKConfig(sdkConfig, andLaunchOptions: nil)
    }
    
    private func setDataCenterIfDeclared() {
        if let setDataCenter = setupCalls["setDataCenter"] {
            let dataCenterAsString = (setDataCenter as! Dictionary<String, Any>)["dataCenter"] as! String
            if (dataCenterAsString == "DATA_CENTER_1") {
                sdkConfig.moeDataCenter = DATA_CENTER_01
            } else if (dataCenterAsString == "DATA_CENTER_2") {
                sdkConfig.moeDataCenter = DATA_CENTER_02
            } else if (dataCenterAsString == "DATA_CENTER_3") {
                sdkConfig.moeDataCenter = DATA_CENTER_03
            }
        }
    }
    
    private func setAppGroupIdIfDeclared() {
        if let setAppGroupId = setupCalls["setAppGroupId"] {
            let appGroupId = (setAppGroupId as! Dictionary<String, Any>)["appGroupId"] as! String
            sdkConfig.appGroupID = appGroupId
        }
    }
    
    private func setAnalyticsDisablePeriodicFlushIfDeclared() {
        if let setAnalyticsDisablePeriodicFlush = setupCalls["setAnalyticsDisablePeriodicFlush"] {
            let analyticsDisablePeriodicFlush = (setAnalyticsDisablePeriodicFlush as! Dictionary<String, Any>)["analyticsDisablePeriodicFlush"] as! Bool
            sdkConfig.analyticsDisablePeriodicFlush = analyticsDisablePeriodicFlush
        }
    }
    
    private func setAnalyticsPeriodicFlushDurationIfDeclared() {
        if let setAnalyticsPeriodicFlushDuration = setupCalls["setAnalyticsPeriodicFlushDuration"] {
            let analyticsPeriodicFlushDuration = (setAnalyticsPeriodicFlushDuration as! Dictionary<String, Any>)["analyticsPeriodicFlushDuration"] as! Int
            sdkConfig.analyticsPeriodicFlushDuration = analyticsPeriodicFlushDuration
        }
    }
    
    private func setEncryptNetworkRequestsIfDeclared() {
        if let setEncryptNetworkRequests = setupCalls["setEncryptNetworkRequests"] {
            let encryptNetworkRequests = (setEncryptNetworkRequests as! Dictionary<String, Any>)["encryptNetworkRequests"] as! Bool
            sdkConfig.encryptNetworkRequests = encryptNetworkRequests
        }
    }
    
    private func setOptOutDataTrackingIfDeclared() {
        if let setOptOutDataTracking = setupCalls["setOptOutDataTracking"] {
            let optOutDataTracking = (setOptOutDataTracking as! Dictionary<String, Any>)["optOutDataTracking"] as! Bool
            sdkConfig.optOutDataTracking = optOutDataTracking
        }
    }
    
    private func setOptOutPushNotificationIfDeclared() {
        if let setOptOutPushNotification = setupCalls["setOptOutPushNotification"] {
            let optOutPushNotification = (setOptOutPushNotification as! Dictionary<String, Any>)["optOutPushNotification"] as! Bool
            sdkConfig.optOutPushNotification = optOutPushNotification
        }
    }
    
    private func setOptOutInAppCampaignIfDeclared() {
        if let setOptOutInAppCampaign = setupCalls["setOptOutInAppCampaign"] {
            let optOutInAppCampaign = (setOptOutInAppCampaign as! Dictionary<String, Any>)["optOutInAppCampaign"] as! Bool
            sdkConfig.optOutInAppCampaign = optOutInAppCampaign
        }
    }
    
    private func setOptOutIDFATrackingIfDeclared() {
        if let setOptOutIDFATracking = setupCalls["setOptOutIDFATracking"] {
            let optOutIDFATracking = (setOptOutIDFATracking as! Dictionary<String, Any>)["optOutIDFATracking"] as! Bool
            sdkConfig.optOutIDFATracking = optOutIDFATracking
        }
    }
    
    private func setOptOutIDFVTrackingIfDeclared() {
        if let setOptOutIDFVTracking = setupCalls["setOptOutIDFVTracking"] {
            let optOutIDFVTracking = (setOptOutIDFVTracking as! Dictionary<String, Any>)["optOutIDFVTracking"] as! Bool
            sdkConfig.optOutIDFVTracking = optOutIDFVTracking
        }
    }
}
