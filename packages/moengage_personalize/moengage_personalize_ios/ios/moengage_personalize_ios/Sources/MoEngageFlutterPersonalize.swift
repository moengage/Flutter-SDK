import Flutter
import UIKit
import MoEngagePluginBase
import MoEngagePluginPersonalize

public class MoEngageFlutterPersonalize: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: MoEngageFlutterPersonalizeConstants.pluginChannelName,
            binaryMessenger: registrar.messenger()
        )
        let instance = MoEngageFlutterPersonalize()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else {
            print("[MoEngageFlutterPersonalize] handle(): invalid payload for \(call.method)")
            result(FlutterError(
                code: "INVALID_PAYLOAD",
                message: "Expected [String: Any] arguments for \(call.method)",
                details: nil
            ))
            return
        }

        switch call.method {
        case MoEngageFlutterPersonalizeConstants.MethodNames.fetchExperiencesMeta:
            MoEngagePluginPersonalizeBridge.sharedInstance.fetchExperiencesMeta(payload) { response in
                DispatchQueue.main.async {
                    MoEngageFlutterPersonalize.sendFetchResult(response, result: result)
                }
            }

        case MoEngageFlutterPersonalizeConstants.MethodNames.fetchExperiences:
            MoEngagePluginPersonalizeBridge.sharedInstance.fetchExperiences(payload) { response in
                DispatchQueue.main.async {
                    MoEngageFlutterPersonalize.sendFetchResult(response, result: result)
                }
            }

        case MoEngageFlutterPersonalizeConstants.MethodNames.trackExperienceShown:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackExperienceShown(payload)
            result(nil)

        case MoEngageFlutterPersonalizeConstants.MethodNames.trackExperienceClicked:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackExperienceClicked(payload)
            result(nil)

        case MoEngageFlutterPersonalizeConstants.MethodNames.trackOfferingShown:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackOfferingShown(payload)
            result(nil)

        case MoEngageFlutterPersonalizeConstants.MethodNames.trackOfferingClicked:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackOfferingClicked(payload)
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Serializes the bridge response dictionary to a JSON string and sends it back to Flutter.
    /// Falls back to `result(nil)` if serialization fails, so the Dart Future never hangs.
    private static func sendFetchResult(_ response: [String: Any], result: FlutterResult) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: response),
           let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
            result(jsonString)
        } else {
            print("[MoEngageFlutterPersonalize] sendFetchResult(): failed to serialize response")
            result(nil)
        }
    }
}
