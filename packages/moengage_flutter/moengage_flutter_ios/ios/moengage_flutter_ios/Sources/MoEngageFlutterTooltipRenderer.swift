//
//  MoEngageFlutterTooltipRenderer.swift
//  moengage_flutter_ios
//
//  Renders a Flutter element - resolved by the Dart element inspector - through the native
//  tooltip API, `MoEngageSDKInApp.showTooltip(frame:title:message:campaignId:config:)`.
//
//  The identifier-based `showTooltip(identifier:...)` resolves either a view's
//  `accessibilityIdentifier` or a `.moeTooltipTag` SwiftUI registry entry, and a Flutter
//  widget has neither, so the frame-based entry point takes the bounds Dart computed
//  instead. The two share one presentation path natively, so the card, placement, beak and
//  callbacks are identical either way.
//
//  Unlike the spotlight, this flows through the real InApp campaign pipeline: an impression
//  is tracked on show and the shown / click / dismiss delegates fire, all keyed on
//  `campaignId`. That is also why dismissal needs the id rather than being global.
//

import UIKit
import MoEngageCore
import MoEngageInApps

enum MoEngageFlutterTooltipRenderer {

    private typealias Keys = MoEngageFlutterConstants.ElementTooltipKeys

    /// Campaign id of the tooltip currently showing, so [dismiss] knows what to close and a
    /// new tooltip can replace one still on screen rather than stacking on it.
    ///
    /// Dart has no campaign concept on this path yet - the hardcoded campaign list keys off
    /// the element - so the element's `nodeId` is used as the id.
    @MainActor private static var activeCampaignId: String?

    /// Shows the tooltip described by a `showElementTooltip` payload. No-op (logged) if the
    /// payload carries no usable bounds.
    static func show(payload: [String: Any]) {
        Task { @MainActor in
            showOnMain(payload: payload)
        }
    }

    /// Re-anchors the showing tooltip to freshly reported bounds, so it follows its element
    /// through a scroll.
    ///
    /// Native's own scroll-follow needs a live `UIView` to watch, which a Flutter widget
    /// doesn't have, so Dart drives this from its scroll notifications instead. This moves the
    /// existing card - `showTooltip` again would track a second impression and stack a second
    /// card on top of the first.
    static func updateAnchor(payload: [String: Any]) {
        Task { @MainActor in
            guard let frame = MoEngageFlutterSpotlightRenderer.screenFrame(from: payload),
                  let campaignId = payload[Keys.kNodeId] as? String,
                  // Ignore an update for a tooltip that is no longer the one showing.
                  campaignId == activeCampaignId else { return }
            MoEngageSDKInApp.sharedInstance.updateTooltipAnchor(campaignId: campaignId, frame: frame)
        }
    }

    /// Dismisses the tooltip currently showing, if any.
    static func dismiss() {
        Task { @MainActor in
            guard let campaignId = activeCampaignId else { return }
            MoEngageSDKInApp.sharedInstance.dismissTooltip(campaignId: campaignId)
            activeCampaignId = nil
        }
    }

    @MainActor
    private static func showOnMain(payload: [String: Any]) {
        guard let frame = MoEngageFlutterSpotlightRenderer.screenFrame(from: payload) else {
            MoEngageLogger.logDefault(logLevel: .warning,
                                      message: "Flutter - Tooltip: could not read bounds from payload \(payload)")
            return
        }

        // The element's own id doubles as the campaign id - see `activeCampaignId`.
        let campaignId = (payload[Keys.kNodeId] as? String).flatMap { $0.isEmpty ? nil : $0 }
            ?? "moe_flutter_tooltip"

        var config = MoEngageTooltipConfig()
        config.side = .auto

        // Replace whatever is already up: two tooltips would otherwise stack, and only the
        // newest would be reachable through `dismiss()`.
        if let previous = activeCampaignId, previous != campaignId {
            MoEngageSDKInApp.sharedInstance.dismissTooltip(campaignId: previous)
        }
        activeCampaignId = campaignId

        MoEngageSDKInApp.sharedInstance.showTooltip(
            frame: frame,
            title: "",
            message: payload[Keys.kMessage] as? String ?? "",
            campaignId: campaignId,
            config: config
        )
    }
}
