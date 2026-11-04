import Flutter
import UIKit
import MoEngageCore
import MoEngagePluginRecommendations

public class MoEngageRecommendationsPlugin: NSObject, FlutterPlugin {
    private let pluginHelper = MoEngagePluginRecommendationsBridge.sharedInstance

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: MoEngageFlutterRecommendationsConstants.pluginChannelName,
            binaryMessenger: registrar.messenger()
        )

        let pluginInstance = MoEngageRecommendationsPlugin()
        registrar.addMethodCallDelegate(pluginInstance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let tag = MoEngageFlutterRecommendationsConstants.logTag

        guard let payload = call.arguments as? [String: Any] else {
            MoEngageLogger.logDefault(
                logLevel: .error,
                message: "\(tag) handle(): invalid arguments for method \(call.method)"
            )
            // Every method on this channel returns a result, so the Dart Future must be settled.
            result(FlutterError(
                code: MoEngageFlutterRecommendationsConstants.FailureReasons.unknownError,
                message: "Failed to capture flutter method channel arguments for method \(call.method)",
                details: nil
            ))
            return
        }

        MoEngageLogger.logDefault(
            logLevel: .verbose,
            message: "\(tag) Got data from client for channel method \(call.method)"
        )

        switch call.method {
        case MoEngageFlutterRecommendationsConstants.FlutterToNativeMethods.fetchRecommendations:
            pluginHelper.fetchRecommendations(payload) { response in
                DispatchQueue.main.async {
                    MoEngageRecommendationsUtil.send(response, to: result)
                }
            }

        default:
            MoEngageLogger.logDefault(
                logLevel: .error,
                message: "\(tag) Flutter method channel not handled for method \(call.method)"
            )
            result(FlutterMethodNotImplemented)
        }
    }
}
