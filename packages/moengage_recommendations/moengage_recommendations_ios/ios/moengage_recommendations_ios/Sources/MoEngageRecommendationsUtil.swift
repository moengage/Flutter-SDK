//
//  MoEngageRecommendationsUtil.swift
//  moengage_recommendations
//

import Flutter
import MoEngageCore

enum MoEngageRecommendationsUtil {
    /// Settles the Dart call with the bridge response.
    ///
    /// A response whose `data` carries a `reason` becomes a `FlutterError` with that reason as its
    /// code; any other response is sent as a JSON string.
    static func send(_ response: [String: Any], to result: FlutterResult) {
        typealias FailureKeys = MoEngageFlutterRecommendationsConstants.FailureKeys
        typealias FailureReasons = MoEngageFlutterRecommendationsConstants.FailureReasons

        if let data = response[FailureKeys.data] as? [String: Any],
           let reason = data[FailureKeys.reason] as? String {
            result(FlutterError(
                code: reason,
                message: data[FailureKeys.message] as? String,
                details: nil
            ))
            return
        }

        // JSONSerialization raises an uncatchable exception on invalid input, so check first.
        guard JSONSerialization.isValidJSONObject(response),
              let data = try? JSONSerialization.data(withJSONObject: response),
              let json = String(data: data, encoding: .utf8)
        else {
            MoEngageLogger.logDefault(
                logLevel: .error,
                message: "\(MoEngageFlutterRecommendationsConstants.logTag) send(): failed to serialize response"
            )
            result(FlutterError(
                code: FailureReasons.parseError,
                message: "Failed to serialize the recommendations response",
                details: nil
            ))
            return
        }

        result(json)
    }
}
