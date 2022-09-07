import Flutter
import UIKit
import MoEngagePluginGeofence

public class MoEngageFlutterGeofence: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MoEngageFlutterGeofenceConstants.channel, binaryMessenger: registrar.messenger())
        let instance = MoEngageFlutterGeofence()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else { return }
        
        if call.method == MoEngageFlutterGeofenceConstants.startGeofenceMonitoring {
            MoEngagePluginGeofenceBridge.sharedInstance.startGeofenceMonitoring(payload)
        }
    }
}
