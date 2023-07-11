//
//  MoEngageCardsPluginLogger.swift
//  moengage_cards
//
//  Created by Soumya Mahunt on 05/07/23.
//

import Foundation
import MoEngageCore
import MoEngagePluginBase

enum MoEngageCardsPluginLogger {
    static let label = "Cards"
    static var sdkInstance: MoEngageSDKInstance?

    static func debug(_ message: String, forData hybridData: [String: Any]) {
        queueLog(message, forData: hybridData, withType: .debug)
    }

    static func error(
        _ message: String,
        forData hybridData: [String: Any] = [:],
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        queueLog(
            message, forData: hybridData, withType: .error,
            file: file, function: function, line: line, column: column
        )
    }

    private static func queueLog(
        _ message: String,
        forData hybridData: [String: Any],
        withType type: MoEngageLoggerType,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        if let sdkInstance = Self.sdkInstance {
            log(
                message, withType: type, inInstance: sdkInstance,
                file: file, function: function, line: line, column: column
            )
        } else if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
            attribute: hybridData
        ) {
            MoEngageConfigCoordinator.sharedInstance.getSdkInstance(identifier) { instance in
                guard let instance = instance else { return }
                Self.sdkInstance = instance
                log(
                    message, withType: type, inInstance: instance,
                    file: file, function: function, line: line, column: column
                )
            }
        } else {
            MoEngageConfigCoordinator.sharedInstance.getDefaultSdkInstance { instance in
                guard let instance = instance else { return }
                Self.sdkInstance = instance
                log(
                    message, withType: type, inInstance: instance,
                    file: file, function: function, line: line, column: column
                )
            }
        }
    }

    private static func log(
        _ message: String,
        withType type: MoEngageLoggerType,
        inInstance sdkInstance: MoEngageSDKInstance,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        switch type {
        case .debug:
            MoEngageLogger.debug(message, label: label, sdkInstance: sdkInstance)
        case .error:
            MoEngageLogger.error(message, label: label, sdkInstance: sdkInstance, fileName: file, functionName: function, lineNumber: line, columnNumber: column)
        case .info:
            MoEngageLogger.info(message, label: label, sdkInstance: sdkInstance, fileName: file, functionName: function, lineNumber: line, columnNumber: column)
        case .verbose:
            MoEngageLogger.verbose(message, label: label, sdkInstance: sdkInstance)
        case .warning:
            MoEngageLogger.warning(message, label: label, sdkInstance: sdkInstance, fileName: file, functionName: function, lineNumber: line, columnNumber: column)
        @unknown default:
            MoEngageLogger.debug(message, label: label, sdkInstance: sdkInstance)
        }
    }
}
