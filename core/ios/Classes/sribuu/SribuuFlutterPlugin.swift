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
    
    // MARK:- Handle Invocation
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == SribuuFlutterConstants.MethodNames.configureMoEngage) {
            configureMoEngage(call: call)
        }
    }
    
    private func configureMoEngage(call: FlutterMethodCall) {
        let arguments = call.arguments as! Dictionary<String, String>
        let appId = arguments["appId"]
        var sdkConfig : MOSDKConfig
        if let config = MoEngage.sharedInstance().getDefaultSDKConfiguration() {
            sdkConfig = config
            sdkConfig.moeAppID = appId!
        }
        else{
            sdkConfig = MOSDKConfig.init(appID: appId!)
        }
        
        MOFlutterInitializer.sharedInstance.initializeWithSDKConfig(sdkConfig, andLaunchOptions: nil)
        
    }
}
