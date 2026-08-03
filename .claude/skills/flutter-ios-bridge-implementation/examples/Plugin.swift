import Flutter
import UIKit
import MoEngageCore
import MoEngagePlugin<featureNameCamel>  // or MoEngagePluginBase for core features

public class MoEngage<featureNameCamel>Plugin: NSObject, FlutterPlugin {
    private let pluginHelper = <iosPluginBridge>.sharedInstance

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: MoEngageFlutter<featureNameCamel>Constants.pluginChannelName,
            binaryMessenger: registrar.messenger()
        )

        let pluginInstance = MoEngage<featureNameCamel>Plugin()
        registrar.addMethodCallDelegate(pluginInstance, channel: channel)
        // Only include below if nativeToHybrid events exist:
        pluginInstance.pluginHelper.set<featureNameCamel>SyncEventListenerDelegate(
            MoEngage<featureNameCamel>SyncListener(producingOnChannel: channel)
        )
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        pluginHelper.onFrameworkDetached()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else {
            MoEngagePlugin<featureNameCamel>Logger.error(
                "Failed to capture flutter method channel arguments for method "
                + "\(call.method) and data \(String(describing: call.arguments))"
            )
            return
        }

        MoEngagePlugin<featureNameCamel>Logger.debug(
            "Got data \(payload) from client for channel method \(call.method)",
            forData: payload
        )

        switch call.method {
        // Fire-and-forget example:
        case MoEngageFlutter<featureNameCamel>Constants.FlutterToNativeMethods.initialize:
            pluginHelper.initialize(payload)

        // Result (async completion) example:
        case MoEngageFlutter<featureNameCamel>Constants.FlutterToNativeMethods.getExampleData:
            pluginHelper.getExampleData(payload) { data in
                MoEngage<featureNameCamel>Util.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }

        default:
            MoEngagePlugin<featureNameCamel>Logger.error(
                "Flutter method channel not handled for method "
                + "\(call.method) and data \(payload)",
                forData: payload
            )
        }
    }
}
