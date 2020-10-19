//
//  MOFlutterConstants.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 09/12/19.
//

import Foundation

struct MOFlutterConstants{
    
    static let kPluginChannelName               = "com.moengage/core"
    
    struct MethodNames {
        static let kInitializeFlutter           = "initialise"
        static let kSetAppStatus                = "setAppStatus"
        static let kTrackEvent                  = "trackEvent"
        static let kSetUserAttribute            = "setUserAttribute"
        static let kSetAlias                    = "setAlias"
        static let kRegisterForPush             = "registerForPush"
        static let kShowInApp                   = "showInApp"
        static let kGetSelfHandledInApp         = "selfHandledInApp"
        static let kUpdateSelfHandledInAppState = "selfHandledCallback"
        static let kSetAppContext               = "setAppContext"
        static let kInvalidateAppContext        = "resetCurrentContext"
        static let kOptOutTracking              = "optOutTracking"
        static let kStartGeofence               = "startGeofenceMonitoring"
        static let kEnableLogs                  = "enableSDKLogs"
        static let kResetUser                   = "logout"
    }
    
    struct CallbackNames {
        static let kPushClicked                 = "onPushClick"
        static let kInAppShown                  = "onInAppShown"
        static let kInAppClicked                = "onInAppClick"
        static let kInAppClickedCustomAction    = "onInAppCustomAction"
        static let kInAppDismissed              = "onInAppDismiss"
        static let kInAppSelfHandled            = "onInAppSelfHandle"
    }
}
