//
//  MoEngageCardsUtil.swift
//  moengage_cards
//
//  Created by Soumya Mahunt on 26/06/23.
//

import Flutter

enum MoEngageCardsUtil {
    static func resume(
        channel method: String,
        havingResult result: @escaping FlutterResult,
        withData data: [String: Any]
    ) {
        let resultData = Self.serialize(data: data)
        MoEngageCardsPluginLogger.debug(
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
