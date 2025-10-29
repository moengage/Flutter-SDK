import Foundation
import Flutter

@objc
public class MoEngageGeofencePlugin: NSObject, FlutterPlugin {
    @objc
    public static func register(with registrar: FlutterPluginRegistrar) {
        MoEngageFlutterGeofence.register(with: registrar)
    }
}
