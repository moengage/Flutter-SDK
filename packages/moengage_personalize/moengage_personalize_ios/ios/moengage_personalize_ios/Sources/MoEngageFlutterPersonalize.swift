import Flutter
import UIKit
import MoEngagePluginBase
import MoEngagePluginPersonalize

public class MoEngageFlutterPersonalize: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: MoEngageFlutterPersonalizeConstants.kPluginChannelName,
            binaryMessenger: registrar.messenger()
        )
        let instance = MoEngageFlutterPersonalize()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else {
            print("Failed to capture flutter method channel arguments for method "
                + "\(call.method), arguments: \(String(describing: call.arguments))")
            result(nil)
            return
        }

        switch call.method {
        case MoEngageFlutterPersonalizeConstants.MethodNames.kFetchExperiencesMeta:
            MoEngagePluginPersonalizeBridge.sharedInstance.fetchExperiencesMeta(payload) { response in
                DispatchQueue.main.async {
                    MoEngageFlutterPersonalize.sendFetchResult(response, result: result)
                }
            }

        case MoEngageFlutterPersonalizeConstants.MethodNames.kFetchExperiences:
            MoEngagePluginPersonalizeBridge.sharedInstance.fetchExperiences(payload) { response in
                DispatchQueue.main.async {
                    MoEngageFlutterPersonalize.sendFetchResult(response, result: result)
                }
            }

        case MoEngageFlutterPersonalizeConstants.MethodNames.kTrackExperienceShown:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackExperienceShown(payload)

        case MoEngageFlutterPersonalizeConstants.MethodNames.kTrackExperienceClicked:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackExperienceClicked(payload)

        case MoEngageFlutterPersonalizeConstants.MethodNames.kTrackOfferingShown:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackOfferingShown(payload)

        case MoEngageFlutterPersonalizeConstants.MethodNames.kTrackOfferingClicked:
            MoEngagePluginPersonalizeBridge.sharedInstance.trackOfferingClicked(payload)

        default:
            print("Invalid invocation: \(call.method)")
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
            print("Failed to serialize personalize response to JSON")
            result(nil)
        }
    }
}
