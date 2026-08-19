import '../internal/constants.dart';
import 'design_mode_element_tag.dart';

/// One highlighted element in a coach mark presentation: which widget to
/// spotlight, where it currently is, and the copy shown beside it.
///
/// A coach mark highlights several elements on one dimmed overlay, so
/// `MoEngageFlutterPlatform.showElementCoachMarks` takes a list of these -
/// unlike the tooltip, beacon and spotlight, which anchor to a single element.
class MoECoachMarkStep {
  /// [MoECoachMarkStep] Constructor
  MoECoachMarkStep({
    required this.nodeId,
    required this.text,
    required this.bounds,
    this.cutoutCornerRadius = 0,
    this.cutoutPadding = 0,
  });

  /// Identity of the highlighted widget - its `ValueKey<String>` value, or the
  /// structural path fallback.
  final String nodeId;

  /// Copy shown beside the highlighted element.
  final String text;

  /// The element's bounds, in physical pixels, resolved by the Dart inspector.
  final DesignModeElementBounds bounds;

  /// Corner radius of the hole punched around the element, in logical pixels.
  ///
  /// A coach mark cutout reveals the *real* widget underneath rather than a copy
  /// of it, so this should match the radius the widget is actually drawn with -
  /// a square-cornered hole over a circular target leaves the app's background
  /// showing in the corners.
  final double cutoutCornerRadius;

  /// Padding added around the element's bounds before punching the hole, in
  /// logical pixels. Defaults to `0`, so the hole matches the element exactly:
  /// any padding reveals a ring of whatever sits behind the widget, which reads
  /// as a halo around the highlight.
  final double cutoutPadding;

  /// Wire form of this step.
  Map<String, dynamic> toMap() => <String, dynamic>{
        keyNodeId: nodeId,
        keyCoachMarkText: text,
        keyBounds: bounds.toMap(),
        keyCoachMarkCutoutCornerRadius: cutoutCornerRadius,
        keyCoachMarkCutoutPadding: cutoutPadding,
      };

  @override
  String toString() => 'MoECoachMarkStep(nodeId: $nodeId, text: $text)';
}
