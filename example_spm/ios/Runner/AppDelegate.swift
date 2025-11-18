import UIKit
import Flutter
import moengage_flutter_ios
import MoEngageSDK
import MoEngageInApps
import MoEngageMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        let yourWorkspaceID = "<YOUR_WORKSPACE_ID>" //Workspace ID: You can be obtain it from App Settings in MoEngage Dashboard.
        let sdkConfig = MoEngageSDKConfig(appId: yourWorkspaceID, dataCenter: .data_center_01)
        sdkConfig.appGroupID = "group.com.alphadevs.MoEngage.NotificationServices"
        sdkConfig.consoleLogConfig = MoEngageConsoleLogConfig(isLoggingEnabled: true, loglevel: .verbose)

        MoEngageSDKCore.sharedInstance.enableAllLogs()
        MoEngageInitializer.sharedInstance.initializeDefaultInstance(sdkConfig, launchOptions: launchOptions)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, willPresent: notification)
        completionHandler([.alert, .sound])
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
        completionHandler()
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
