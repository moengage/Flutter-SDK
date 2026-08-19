//
//  MoEngageFlutterCoachMarkRenderer.swift
//  moengage_flutter_ios
//
//  Renders several resolved Flutter elements - reported by the Dart element inspector - on one
//  dimmed overlay through `MoEngageCoachMarkPresenter`.
//
//  Unlike the other three overlays this takes a *list*: a coach mark highlights every target
//  of a walkthrough at the same time, so all of them must be resolved before anything renders.
//
//  `MoEngageCoachMarkConfig` has two initialisers. The identifier one highlights an element by
//  copying it above the scrim (a `snapshotView` for UIKit, a `UIHostingController` for
//  SwiftUI), which a Flutter widget can't supply - there is nothing to copy. The
//  `targetFrame:` one instead punches a hole through the scrim so the real Flutter content
//  shows through, which is the path used here.
//
//  Because the cutout reveals the actual widget rather than a copy, `cutoutCornerRadius`
//  should match the widget's real radius and `cutoutPadding` defaults to 0 - any padding
//  exposes a ring of whatever sits behind the widget, which reads as a halo.
//

import UIKit
import MoEngageCore
import MoEngageInApps

enum MoEngageFlutterCoachMarkRenderer {

    private typealias Keys = MoEngageFlutterConstants.ElementTooltipKeys
    private typealias CoachKeys = MoEngageFlutterConstants.CoachMarkKeys

    /// Shows coach marks for every step in a `showElementCoachMarks` payload. Steps without
    /// usable bounds are dropped; nothing is shown if none survive.
    static func show(payload: [String: Any]) {
        Task { @MainActor in
            showOnMain(payload: payload)
        }
    }

    /// Dismisses the coach mark overlay, if one is showing.
    static func dismiss() {
        MoEngageCoachMarkPresenter.dismiss()
    }

    @MainActor
    private static func showOnMain(payload: [String: Any]) {
        guard let steps = payload[CoachKeys.kSteps] as? [[String: Any]], !steps.isEmpty else {
            MoEngageLogger.logDefault(logLevel: .warning,
                                      message: "Flutter - CoachMark: no steps in payload \(payload)")
            return
        }

        let configs = steps.compactMap { step -> MoEngageCoachMarkConfig? in
            guard let frame = MoEngageFlutterSpotlightRenderer.screenFrame(from: step) else {
                MoEngageLogger.logDefault(logLevel: .warning,
                                          message: "Flutter - CoachMark: could not read bounds for step \(step), dropping it")
                return nil
            }
            let radius = (step[CoachKeys.kCutoutCornerRadius] as? NSNumber)?.doubleValue ?? 0
            let padding = (step[CoachKeys.kCutoutPadding] as? NSNumber)?.doubleValue ?? 0
            return MoEngageCoachMarkConfig(
                targetFrame: frame,
                text: step[CoachKeys.kText] as? String ?? "",
                cutoutCornerRadius: CGFloat(radius),
                cutoutPadding: CGFloat(padding)
            )
        }

        guard !configs.isEmpty else {
            MoEngageLogger.logDefault(logLevel: .warning,
                                      message: "Flutter - CoachMark: no step resolved, nothing shown")
            return
        }
        MoEngageCoachMarkPresenter.show(with: configs)
    }
}
