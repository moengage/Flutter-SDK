import UIKit
import Flutter
import moengage_flutter
import MoEngage

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Update your SDK Config here.
    var sdkConfig : MOSDKConfig
    let yourAppID = "DAO6UGZ73D9RTK8B5W96TPYN" //App ID: You can be obtain it from App Settings in MoEngage Dashboard.
    if let config = MoEngage.sharedInstance().getDefaultSDKConfiguration() {
        sdkConfig = config
        sdkConfig.moeAppID = yourAppID
    }
    else{
        sdkConfig = MOSDKConfig.init(appID: yourAppID)
    }
    sdkConfig.appGroupID = "group.com.alphadevs.MoEngage.NotificationServices"
    sdkConfig.moeDataCenter = DATA_CENTER_01
    sdkConfig.optOutIDFATracking = true
    sdkConfig.optOutIDFVTracking = false
    sdkConfig.optOutDataTracking = false
    sdkConfig.optOutPushNotification = false
    sdkConfig.optOutInAppCampaign = false
    
    MOFlutterInitializer.sharedInstance.initializeWithSDKConfig(sdkConfig, andLaunchOptions: launchOptions)
    
    MoEngage.enableSDKLogs(true)
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
