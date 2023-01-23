import UIKit
import Flutter
import moengage_flutter
import MoEngageSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var flutterViewController: FlutterViewController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let yourAppID = "DAO6UGZ73D9RTK8B5W96TPYN" //App ID: You can be obtain it from App Settings in MoEngage Dashboard.
      let sdkConfig = MoEngageSDKConfig(withAppID: yourAppID)
      sdkConfig.appGroupID = "group.com.alphadevs.MoEngage.NotificationServices"
      sdkConfig.enableLogs = true
      
      MoEngageInitializer.sharedInstance.initializeDefaultInstance(sdkConfig, launchOptions: launchOptions)
        
      
      flutterViewController = FlutterViewController()
      let nav = UINavigationController.init(rootViewController: flutterViewController!)
      nav.isNavigationBarHidden = true
      
      let window = UIWindow()
      self.window = window
      window.rootViewController = nav
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        if let vc = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
            return
        }
    }

    override func registrar(forPlugin: String) -> FlutterPluginRegistrar {
        return (self.flutterViewController?.registrar(forPlugin: forPlugin))!
    }

    override func hasPlugin(_ pluginKey: String) -> Bool {
        return (self.flutterViewController?.hasPlugin(pluginKey))!
    }

    override func valuePublished(byPlugin pluginKey: String) -> NSObject {
        return (self.flutterViewController?.valuePublished(byPlugin: pluginKey))!
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
