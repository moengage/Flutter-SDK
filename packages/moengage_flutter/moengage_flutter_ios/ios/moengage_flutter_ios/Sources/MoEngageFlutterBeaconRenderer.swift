//
//  MoEngageFlutterBeaconRenderer.swift
//  moengage_flutter_ios
//
//  Renders a Flutter element - resolved by the Dart element inspector - through the native
//  beacon API, `MoEngageSDKInApp.showBeacon(frame:title:message:campaignId:config:)`.
//
//  Natively an iOS beacon is a dot that can expand into a tooltip card -
//  `MoEngageBeaconConfig` nests a `MoEngageTooltipConfig` for that expanded state. Android's
//  `MoEBeaconHelper` is a standalone pulsating dot, so this renderer configures for the dot
//  alone to keep the two platforms aligned; see [showOnMain] for what config can and cannot
//  enforce there.
//
//  Like the tooltip renderer - and unlike the spotlight one - this flows through the real
//  InApp campaign pipeline: an impression on show, a click when the dot is tapped to expand,
//  and a dismiss when the card closes, all keyed on `campaignId`.
//

import UIKit
import MoEngageCore
import MoEngageInApps

enum MoEngageFlutterBeaconRenderer {

    private typealias Keys = MoEngageFlutterConstants.ElementTooltipKeys

    /// Campaign id of the beacon currently showing, so [dismiss] knows what to close and a
    /// new beacon can replace one still up rather than stacking on it.
    ///
    /// Dart has no campaign concept on this path yet, so the element's `nodeId` is the id -
    /// same convention as `MoEngageFlutterTooltipRenderer`.
    @MainActor private static var activeCampaignId: String?

    /// Shows the beacon described by a `showElementTooltip` payload. No-op (logged) if the
    /// payload carries no usable bounds.
    static func show(payload: [String: Any]) {
        Task { @MainActor in
            showOnMain(payload: payload)
        }
    }

    /// Re-anchors the showing beacon - dot and expanded card alike - to freshly reported
    /// bounds, so it follows its element through a scroll.
    ///
    /// Native's own scroll-follow needs a live `UIView` to watch, which a Flutter widget
    /// doesn't have, so Dart drives this from its scroll notifications instead.
    static func updateAnchor(payload: [String: Any]) {
        Task { @MainActor in
            guard let frame = MoEngageFlutterSpotlightRenderer.screenFrame(from: payload),
                  let campaignId = payload[Keys.kNodeId] as? String,
                  // Ignore an update for a beacon that is no longer the one showing.
                  campaignId == activeCampaignId else { return }
            MoEngageSDKInApp.sharedInstance.updateBeaconAnchor(campaignId: campaignId, frame: frame)
        }
    }

    /// Dismisses the beacon currently showing, if any.
    static func dismiss() {
        Task { @MainActor in
            guard let campaignId = activeCampaignId else { return }
            MoEngageSDKInApp.sharedInstance.dismissBeacon(campaignId: campaignId)
            activeCampaignId = nil
        }
    }

    @MainActor
    private static func showOnMain(payload: [String: Any]) {
        guard let frame = MoEngageFlutterSpotlightRenderer.screenFrame(from: payload) else {
            MoEngageLogger.logDefault(logLevel: .warning,
                                      message: "Flutter - Beacon: could not read bounds from payload \(payload)")
            return
        }

        let campaignId = (payload[Keys.kNodeId] as? String).flatMap { $0.isEmpty ? nil : $0 }
            ?? "moe_flutter_beacon"

        // Hardcoded here rather than sent from Dart: the plugin's element payload carries only
        // bounds, message and overlay type, so there is nowhere to put dot styling yet. Change
        // these values to try other looks.
        var config = MoEngageBeaconConfig()

        // Dot only, matching Android's `MoEBeaconHelper` - a standalone pulsating dot.
        // `twoStep = false` would show the card immediately and make the beacon
        // indistinguishable from a tooltip; any `autoExpand > 0` pops the card open on a timer.
        config.twoStep = true
        config.autoExpand = 0

        // An expanding-ring dot on the element's top-right corner - the same look as the
        // native demo app's beacon screen.
        config.alignment = .topRight
        config.animation = .ripple
        config.dotDiameter = 16

        // Tapping the dot still expands it into a card: the native controller wires `onExpand`
        // unconditionally, and the dot carries both a tap recogniser and a "Learn more"
        // accessibility action. Suppressing that would need a native flag - there is no
        // `expandOnTap` today - so the expanded card is styled to at least look deliberate.
        config.tooltip.side = .auto

        // Replace whatever is already up: two beacons would otherwise stack, and only the
        // newest would be reachable through `dismiss()`.
        if let previous = activeCampaignId, previous != campaignId {
            MoEngageSDKInApp.sharedInstance.dismissBeacon(campaignId: previous)
        }
        activeCampaignId = campaignId

        MoEngageSDKInApp.sharedInstance.showBeacon(
            frame: frame,
            title: "",
            message: payload[Keys.kMessage] as? String ?? "",
            campaignId: campaignId,
            config: config
        )
    }
}
