import Flutter
import UIKit
import MoEngageCore
// TODO(MOEN-47187): MoEngagePluginRecommendations / MoEngagePluginRecommendationsBridge do not
// exist yet in moengage/iOS-PluginBase (no tag, branch, or PR as of this writing). This file
// mirrors MoEngageCardsPlugin.swift's "result" method pattern and MUST be verified — method name,
// completion signature, and failure reporting — against the real bridge once it ships.
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

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        pluginHelper.onFrameworkDetached()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else {
            MoEngagePluginRecommendationsLogger.error(
                "Failed to capture flutter method channel arguments for method "
                + "\(call.method) and data \(String(describing: call.arguments))"
            )
            // Settled rather than dropped — every method on this channel returns a result, so
            // returning silently would leave the Dart Future pending forever.
            result(FlutterError(
                code: "UNKNOWN_ERROR",
                message: "Failed to capture flutter method channel arguments for method \(call.method)",
                details: nil
            ))
            return
        }

        MoEngagePluginRecommendationsLogger.debug(
            "Got data \(payload) from client for channel method \(call.method)",
            forData: payload
        )

        switch call.method {
        case MoEngageFlutterRecommendationsConstants.FlutterToNativeMethods.fetchRecommendations:
            // TODO(MOEN-47187): confirm whether the real bridge reports failures via a second
            // closure parameter (mirroring Android's `RecommendationsListener.onFailure(reason,
            // message)`), a `Result<[String: Any], Error>`, or a thrown error, and update this
            // call site accordingly.
            pluginHelper.fetchRecommendations(payload) { data, error in
                if let error = error {
                    DispatchQueue.main.async {
                        result(FlutterError(
                            code: error.reason,
                            message: error.message,
                            details: nil
                        ))
                    }
                    return
                }
                MoEngageRecommendationsUtil.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }

        default:
            MoEngagePluginRecommendationsLogger.error(
                "Flutter method channel not handled for method "
                + "\(call.method) and data \(payload)",
                forData: payload
            )
            result(FlutterMethodNotImplemented)
        }
    }
}
