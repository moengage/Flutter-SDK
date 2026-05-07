import Foundation
import Flutter

@objc
public class MoEngagePersonalizePlugin: NSObject, FlutterPlugin {
    @objc
    public static func register(with registrar: FlutterPluginRegistrar) {
        MoEngageFlutterPersonalize.register(with: registrar)
    }
}
