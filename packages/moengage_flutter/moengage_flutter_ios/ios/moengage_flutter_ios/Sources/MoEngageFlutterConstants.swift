//
//  MoEngageFlutterConstants.swift
//  flutter_moengage_plugin
//
//  Created by Chengappa C D on 09/12/19.
//

import Foundation

struct MoEngageFlutterConstants{
    
    static let kPluginChannelName               = "com.moengage/core"
    static let kPluginName                      = "flutter"
    
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
        static let kShowNudge                   = "showNudge"
        static let kOptOutTracking              = "optOutTracking"
        static let kUpdateSDKState              = "updateSdkState"
        static let kStartGeofence               = "startGeofenceMonitoring"
        static let kEnableLogs                  = "enableSDKLogs"
        static let kResetUser                   = "logout"
        static let kGetSelfHandleInApps         = "selfHandledInApps"
        static let kRegisterForProvisionalPush  = "registerForProvisionalPush"
        static let kIdentifyUser                = "identifyUser"
        static let kGetUserIdentities           = "getUserIdentities"

        // Element-anchored overlays. Dart resolves a widget's bounds and sends
        // them here, since a Flutter widget has no UIView for the native
        // identifier-based resolvers to find.
        static let kShowElementTooltip          = "showElementTooltip"
        static let kDismissElementTooltip       = "dismissElementTooltip"
        static let kUpdateElementTooltipAnchor  = "updateElementTooltipAnchor"
        static let kShowElementCoachMarks       = "showElementCoachMarks"
        static let kDismissElementCoachMarks    = "dismissElementCoachMarks"
    }

    /// Keys of the `showElementCoachMarks` payload. Each step also carries the
    /// shared [ElementTooltipKeys.kBounds].
    struct CoachMarkKeys {
        static let kSteps                       = "steps"
        static let kText                        = "text"
        static let kCutoutCornerRadius          = "cutoutCornerRadius"
        static let kCutoutPadding               = "cutoutPadding"
    }

    /// Keys of the `showElementTooltip` payload - a `DesignModeElementTag.toMap()`
    /// plus the message and overlay type.
    struct ElementTooltipKeys {
        static let kBounds                      = "bounds"
        static let kBoundsTop                   = "top"
        static let kBoundsLeft                  = "left"
        static let kBoundsBottom                = "bottom"
        static let kBoundsRight                 = "right"
        static let kNodeId                      = "nodeId"
        static let kMessage                     = "message"
        static let kOverlayType                 = "overlayType"
    }

    /// Values of [ElementTooltipKeys.kOverlayType], matching
    /// `NativeTooltipOverlayType.wireValue` on the Dart side.
    struct ElementOverlayType {
        static let kTooltip                     = "tooltip"
        static let kBeacon                      = "beacon"
        static let kSpotlight                   = "spotlight"
        static let kCoachMark                   = "coachMark"
    }
    
    struct CallbackNames {
        static let kPushTokenGenerated          = "onPushTokenGenerated"
        static let kPushClicked                 = "onPushClick"
        static let kInAppShown                  = "onInAppShown"
        static let kInAppClicked                = "onInAppClick"
        static let kInAppClickedCustomAction    = "onInAppCustomAction"
        static let kInAppDismissed              = "onInAppDismiss"
        static let kInAppSelfHandled            = "onInAppSelfHandle"
        static let kLogoutComplete              = "onLogoutComplete"
    }
}
