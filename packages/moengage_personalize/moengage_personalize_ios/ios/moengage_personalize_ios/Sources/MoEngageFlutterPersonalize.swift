import Flutter
import UIKit
import MoEngageCore
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
            MoEngageLogger.logDefault(
                message: "[MoEngageFlutterPersonalize] handle(): invalid payload for \(call.method)"
            )
            result(FlutterError(
                code: "INVALID_PAYLOAD",
                message: "Expected [String: Any] arguments for \(call.method)",
                details: nil
            ))
            return
        }

        MoEngageLogger.logDefault(
            logLevel: .verbose,
            message: "[MoEngageFlutterPersonalize] Got data from client for channel method \(call.method)"
        )

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

        case MoEngageFlutterPersonalizeConstants.MethodNames.experiencesShown:
            MoEngagePluginPersonalizeBridge.sharedInstance.experiencesShown(payload)
            result(nil)

        case MoEngageFlutterPersonalizeConstants.MethodNames.experienceClicked:
            MoEngagePluginPersonalizeBridge.sharedInstance.experienceClicked(payload)
            result(nil)

        case MoEngageFlutterPersonalizeConstants.MethodNames.offeringsShown:
            MoEngagePluginPersonalizeBridge.sharedInstance.offeringsShown(payload)
            result(nil)

        case MoEngageFlutterPersonalizeConstants.MethodNames.offeringClicked:
            MoEngagePluginPersonalizeBridge.sharedInstance.offeringClicked(payload)
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
            MoEngageLogger.logDefault(
                message: "[MoEngageFlutterPersonalize] sendFetchResult(): failed to serialize response"
            )
            result(nil)
        }
    }
}
