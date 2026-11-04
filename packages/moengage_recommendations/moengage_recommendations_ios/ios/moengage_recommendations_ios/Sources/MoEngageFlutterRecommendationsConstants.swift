//
//  MoEngageFlutterRecommendationsConstants.swift
//  moengage_recommendations
//

import Foundation

enum MoEngageFlutterRecommendationsConstants {
    static let pluginChannelName = "com.moengage/recommendations"
    static let logTag = "[MoEngageFlutterRecommendations]"

    enum FlutterToNativeMethods {
        static let fetchRecommendations = "fetchRecommendations"
    }

    /// Keys of the failure payload returned by the plugin bridge.
    enum FailureKeys {
        static let data = "data"
        static let reason = "reason"
        static let message = "message"
    }

    /// Failure reasons raised by this plugin itself.
    enum FailureReasons {
        static let unknownError = "UNKNOWN_ERROR"
        static let parseError = "PARSE_ERROR"
    }
}
