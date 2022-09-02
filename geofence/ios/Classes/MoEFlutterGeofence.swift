import Flutter
import UIKit
import MoEPluginGeofence

public class MoEFlutterGeofence: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MoEFlutterGeofenceConstants.channel, binaryMessenger: registrar.messenger())
        let instance = MoEFlutterGeofence()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else { return }
        
        if call.method == MoEFlutterGeofenceConstants.startGeofenceMonitoring {
            MoEGeofenceBridge.sharedInstance.startGeofenceMonitoring(payload)
        }
    }
}
