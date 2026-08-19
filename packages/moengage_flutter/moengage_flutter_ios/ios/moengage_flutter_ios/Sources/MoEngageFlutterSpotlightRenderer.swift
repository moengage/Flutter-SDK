//
//  MoEngageFlutterSpotlightRenderer.swift
//  moengage_flutter_ios
//
//  Renders a Flutter element - resolved by the Dart element inspector and reported as a
//  `DesignModeElementTag` - through the native `MoEngageSDKSpotlight` overlay.
//
//  Flutter paints its whole UI onto a single Skia surface, so a widget has no `UIView` of
//  its own. The tag-based `showSpotlight(tag:)` API resolves either a SwiftUI registry
//  entry or a view's `accessibilityIdentifier`, and can find neither. Dart therefore
//  computes the element's bounds itself and this renderer passes them to the frame-based
//  `showSpotlight(frame:config:)` entry point. No marker view is needed: the native
//  spotlight draws into its own window above the `FlutterView` already.
//
//  See `NativeTooltipRenderer.kt` for the Android counterpart, which *does* need a marker
//  `View` because `MoESpotlightHelper` only accepts a real anchor view.
//

import UIKit
import MoEngageCore
import MoEngageInApps

enum MoEngageFlutterSpotlightRenderer {

    private typealias Keys = MoEngageFlutterConstants.ElementTooltipKeys

    /// Shows the overlay described by a `showElementTooltip` payload. No-op (logged) if the
    /// payload carries no usable bounds.
    static func show(payload: [String: Any]) {
        Task { @MainActor in
            showOnMain(payload: payload)
        }
    }

    /// Dismisses the spotlight currently showing, if any.
    static func dismiss() {
        Task { @MainActor in
            MoEngageSDKSpotlight.sharedInstance.dismissSpotlight()
        }
    }

    @MainActor
    private static func showOnMain(payload: [String: Any]) {
        guard let frame = screenFrame(from: payload) else {
            MoEngageLogger.logDefault(logLevel: .warning,
                                      message: "Flutter - Spotlight: could not read bounds from payload \(payload)")
            return
        }

        let config = MoEngageSpotlightConfig()
        config.message = payload[Keys.kMessage] as? String ?? ""

        // `.automatic` inspects the target's layer to infer a shape, and a Flutter element
        // has no layer to inspect - it would fall back to a plain rectangle. A rounded
        // rectangle suits the list rows and buttons a campaign anchors to, and is the
        // closest match to Android's default.
        config.cutoutShape = .roundedRectangle
        config.cutoutCornerRadius = 8

        MoEngageSDKSpotlight.sharedInstance.showSpotlight(frame: frame, config: config)
    }

    /// Converts the payload's `bounds` - **physical pixels** relative to the Flutter view's
    /// origin, as `DesignModeElementBounds` documents - into a screen-coordinate `CGRect`
    /// in points, which is what the native spotlight expects.
    ///
    /// Skipping either half of this places the overlay roughly 2-3x too far down-right on a
    /// Retina screen.
    @MainActor
    static func screenFrame(from payload: [String: Any]) -> CGRect? {
        guard let bounds = payload[Keys.kBounds] as? [String: Any],
              let top = (bounds[Keys.kBoundsTop] as? NSNumber)?.doubleValue,
              let left = (bounds[Keys.kBoundsLeft] as? NSNumber)?.doubleValue,
              let bottom = (bounds[Keys.kBoundsBottom] as? NSNumber)?.doubleValue,
              let right = (bounds[Keys.kBoundsRight] as? NSNumber)?.doubleValue,
              right > left, bottom > top else { return nil }

        let window = keyWindow()
        let scale = window?.screen.scale ?? UIScreen.main.scale
        let inWindow = CGRect(x: left / scale,
                              y: top / scale,
                              width: (right - left) / scale,
                              height: (bottom - top) / scale)

        // Flutter's coordinates are relative to its own view, which fills the window in a
        // standard Flutter app; the window in turn may be offset from the screen (iPad
        // multitasking / Stage Manager), so convert the same way the SDK's own UIKit
        // resolver does before handing the rect over.
        guard let window else { return inWindow }
        return window.convert(inWindow, to: window.screen.coordinateSpace)
    }

    @MainActor
    private static func keyWindow() -> UIWindow? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
            ?? scenes.first { $0.activationState == .foregroundActive }?.windows.first
            ?? scenes.first?.windows.first
    }
}
