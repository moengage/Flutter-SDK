import Foundation
import Flutter

@objc
public class MoEngageSamplePlugin: NSObject, FlutterPlugin {
    @objc
    public static func register(with registrar: FlutterPluginRegistrar) {
        MoEngageFlutterSample.register(with: registrar)
    }
}
