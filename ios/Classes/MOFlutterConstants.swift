//
//  MOFlutterConstants.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 09/12/19.
//

import Foundation

struct MOFlutterConstants{
    
    static let kPluginChannelName               = "flutter_moengage_plugin"
    
    struct MethodNames {
        static let kSetAppStatus                = "setAppStatus"
        static let kTrackEvent                  = "trackEvent"
        static let kSetAlias                    = "setAlias"
        static let kSetUserAttribute            = "setUserAttribute"
        static let kSetUserAttributeLocation    = "setUserAttributeLocation"
        static let kSetUserAttributeTimestamp   = "setUserAttributeTimestamp"
        static let kResetUser                   = "logout"
        static let kRegisterForPush             = "registerForiOSPushNotification"
        static let kShowInApp                   = "showInApp"
        static let kInitializeFlutter               = "initialise"
    }
    
    struct CallbackNames {
        static let kPushClicked                 = "onPushClick"
        static let kInAppShown                  = "onInAppShown"
        static let kInAppClicked                = "onInAppClick"
    }
    
    struct ArgumentKeys {
        static let kAttributeName               = "attributeName"
        static let kAttributeValue              = "attributeValue"
        static let kAttributeLatValue           = "latitude"
        static let kAttributeLngValue           = "longitude"
        
        static let kAttributeEventName          = "eventName"
        static let kAttributeEventAttrs         = "eventAttributes"
        static let kAttributeEventGeneralAttrs  = "generalAttributes"
        static let kAttributeEventDateAttrs     = "dateTimeAttributes"
        static let kAttributeEventLocationAttrs = "locationAttributes"
        static let kAttributeIsNonInteractive   = "isNonInteractive"
    }
}
