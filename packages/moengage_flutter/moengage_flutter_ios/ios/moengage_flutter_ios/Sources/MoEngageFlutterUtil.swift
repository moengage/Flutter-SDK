//
//  MoEngageFlutterUtil.swift
//  moengage_flutter_ios
//
//  Created by Rakshitha on 11/09/24.
//

import Flutter
import Foundation
import MoEngageCore

enum MoEngageFlutterUtil {
    static func resume(channel method: String, havingResult result: @escaping FlutterResult, withData data: [String: Any]) {
        let resultData = serialize(data: data)
        MoEngageLogger.logDefault(message: "Response payload in PluginBase for method  - \(method) is \(resultData)")
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
