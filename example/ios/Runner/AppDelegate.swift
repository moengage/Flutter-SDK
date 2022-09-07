import UIKit
import Flutter
import moengage_flutter
import MoEngageSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let yourAppID = "DAO6UGZ73D9RTK8B5W96TPYN" //App ID: You can be obtain it from App Settings in MoEngage Dashboard.
    let sdkConfig = MOSDKConfig(withAppID: yourAppID)
    sdkConfig.enableLogs = true
    
    MoEngageInitializer.sharedInstance.initializeDefaultInstance(sdkConfig, launchOptions: launchOptions)
    
    MoEngage.enableSDKLogs(true)
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Opening deeplink", url)
        return true
    }
    
    override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print("Opening Universal link", userActivityType)
        return false
    }
}
