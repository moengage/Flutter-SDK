import Foundation
import Flutter

@objc
public class MoEngageInboxPlugin: NSObject, FlutterPlugin {
    @objc
    public static func register(with registrar: FlutterPluginRegistrar) {
        MoEngageFlutterInbox.register(with: registrar)
    }
}
