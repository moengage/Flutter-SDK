import Flutter
import UIKit
import MoEngageCore
import MoEngagePluginCards

public class MoEngageCardsPlugin: NSObject, FlutterPlugin {
    private let pluginHelper = MoEngagePluginCardsBridge.sharedInstance

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: MoEngageFlutterCardsConstants.pluginChannelName,
            binaryMessenger: registrar.messenger()
        )

        let pluginInstance = MoEngageCardsPlugin()
        registrar.addMethodCallDelegate(pluginInstance, channel: channel)
        pluginInstance.pluginHelper.setSyncEventListnerDelegate(
            MoEngageCardSyncListner(producingOnChannel: channel)
        )
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        pluginHelper.onFrameworkDetached()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let payload = call.arguments as? [String: Any] else {
            MoEngagePluginCardsLogger.error(
                "Failed to capture flutter method channel arguments for method "
                + "\(call.method) and data \(String(describing: call.arguments))"
            )
            return
        }

        MoEngagePluginCardsLogger.debug(
            "Got data \(payload) from client for channel method \(call.method)",
            forData: payload
        )

        switch call.method {
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.initialize:
            pluginHelper.initialize(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.refreshCards:
            pluginHelper.refreshCards(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.onCardSectionLoaded:
            pluginHelper.onCardsSectionLoaded(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.setAppOpenCardsSyncListener:
            pluginHelper.setAppOpenSyncListener(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.onCardSectionUnloaded:
            pluginHelper.onCardsSectionUnLoaded(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.getCardsCategories:
            pluginHelper.getCardsCategories(payload) { data in
                MoEngageCardsUtil.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.cardsInfo:
            pluginHelper.getCardsInfo(payload) { data in
                MoEngageCardsUtil.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.cardClicked:
            pluginHelper.cardClicked(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.cardDelivered:
            pluginHelper.cardDelivered(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.cardShown:
            pluginHelper.cardShown(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.cardsForCategory:
            pluginHelper.getCardsForCategory(payload) { data in
                MoEngageCardsUtil.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.deleteCards:
            pluginHelper.deleteCards(payload)
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.isAllCategoryEnabled:
            pluginHelper.isAllCategoryEnabled(payload) { data in
                MoEngageCardsUtil.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.newCardsCount:
            pluginHelper.getNewCardsCount(payload) { data in
                MoEngageCardsUtil.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }
        case MoEngageFlutterCardsConstants.FlutterToNativeMethods.unClickedCardsCount:
            pluginHelper.getUnClickedCardsCount(payload) { data in
                MoEngageCardsUtil.resume(
                    channel: call.method,
                    havingResult: result,
                    withData: data
                )
            }
        default:
            MoEngagePluginCardsLogger.error(
                "Flutter method channel not handled for method "
                + "\(call.method) and data \(payload)",
                forData: payload
            )
        }
    }
}
