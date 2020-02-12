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
    
    MoEngage.debug(LOG_ALL)
    // Update your App ID here. You can be obtain it from App Settings in MoEngage Dashboard.
    MOFlutterInitializer.sharedInstance.initializeWithAppID("Your App ID", withLaunchOptions: launchOptions)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
