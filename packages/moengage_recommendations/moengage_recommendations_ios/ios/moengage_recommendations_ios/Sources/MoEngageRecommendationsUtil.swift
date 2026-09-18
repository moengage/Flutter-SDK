//
//  MoEngageRecommendationsUtil.swift
//  moengage_recommendations
//

import Flutter
// TODO(MOEN-47187): verify the actual module name once MoEngagePluginRecommendations ships —
// mirrors MoEngagePluginCards below, but the plugin-base module does not exist yet.
import MoEngagePluginRecommendations

enum MoEngageRecommendationsUtil {
    static func resume(
        channel method: String,
        havingResult result: @escaping FlutterResult,
        withData data: [String: Any]
    ) {
        let resultData = Self.serialize(data: data)
        MoEngagePluginRecommendationsLogger.debug(
            "Providing data \(data) to client for channel method \(method)",
            forData: data
        )
        DispatchQueue.main.async { result(resultData) }
    }

    static func serialize(data: [String: Any]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: data),
           let jsonStr = String(data: jsonData, encoding: .utf8) {
            return jsonStr
        } else {
            return ""
        }
    }
}
