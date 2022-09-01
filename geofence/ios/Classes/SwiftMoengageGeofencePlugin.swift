import Flutter
import UIKit
import MoEPluginGeofence

public class SwiftMoengageGeofencePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.moengage/geofence", binaryMessenger: registrar.messenger())
        let instance = SwiftMoengageGeofencePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else { return }
        
        if call.method == "startGeofenceMonitoring" {
            MoEGeofenceBridge.sharedInstance.startGeofenceMonitoring(payload)
        }
    }
}
