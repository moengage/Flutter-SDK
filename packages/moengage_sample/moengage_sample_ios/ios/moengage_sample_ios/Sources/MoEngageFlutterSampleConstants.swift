//
//  MoEngageFlutterSampleConstants.swift
//  moengage_sample
//
//  Reference/scaffold module - constants for the `moengage_sample` iOS bridge.
//

import Foundation

struct MoEngageFlutterSampleConstants {

    static let kPluginChannelName = "com.moengage/sample"

    struct MethodNames {
        static let kGreet = "greet"
    }

    struct PayloadKeys {
        static let kAccountMeta = "accountMeta"
        static let kAppId = "appId"
    }
}
