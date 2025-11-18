import Foundation
import Flutter

@objc
public class MoEngageFlutterPlugin: NSObject, FlutterPlugin {
    @objc
    public static func register(with registrar: FlutterPluginRegistrar) {
        MoEngageFlutterBridge.register(with: registrar)
    }
}