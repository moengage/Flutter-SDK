/// Which native `com.moengage:tooltip` overlay to render for a resolved
/// Flutter element anchor - see `MoETooltipHelper`, `MoEBeaconHelper` and
/// `MoESpotlightHelper` in the native Android SDK's `tooltip` module.
enum NativeTooltipOverlayType {
  /// A speech-bubble tooltip anchored above/below the element.
  tooltip,

  /// A pulsating dot anchored to a corner of the element; tapping it reveals
  /// a tooltip.
  beacon,

  /// A dimmed full-screen scrim with a cutout around the element.
  spotlight,

  /// A dimmed overlay highlighting several elements at once, each with its own
  /// copy - a walkthrough rather than a single callout. Unlike the others this
  /// takes a list of targets, so it goes through
  /// `showElementCoachMarks` rather than `showElementTooltip`.
  coachMark,
}

/// Wire encoding for [NativeTooltipOverlayType], sent to native over the
/// method channel as `keyTooltipOverlayType`.
extension NativeTooltipOverlayTypeWireValue on NativeTooltipOverlayType {
  /// The `overlayType` string this value is encoded as on the wire.
  String get wireValue {
    switch (this) {
      case NativeTooltipOverlayType.tooltip:
        return 'tooltip';
      case NativeTooltipOverlayType.beacon:
        return 'beacon';
      case NativeTooltipOverlayType.spotlight:
        return 'spotlight';
      case NativeTooltipOverlayType.coachMark:
        return 'coachMark';
    }
  }
}
