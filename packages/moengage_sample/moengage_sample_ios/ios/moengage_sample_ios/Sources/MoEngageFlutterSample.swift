import Flutter
import UIKit

public class MoEngageFlutterSample: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MoEngageFlutterSampleConstants.kPluginChannelName, binaryMessenger: registrar.messenger())
        let instance = MoEngageFlutterSample()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case MoEngageFlutterSampleConstants.MethodNames.kGreet:
            guard let payload = call.arguments as? [String: Any],
                  let accountMeta = payload[MoEngageFlutterSampleConstants.PayloadKeys.kAccountMeta] as? [String: Any],
                  let appId = accountMeta[MoEngageFlutterSampleConstants.PayloadKeys.kAppId] as? String else {
                result(nil)
                return
            }
            result("Hello from MoEngage Sample (iOS), appId: \(appId)")

        default:
            print("Invalid invocation: \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }
}
