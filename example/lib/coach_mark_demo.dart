// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'package:flutter/material.dart';

/// Demo surface for the coach mark overlay.
///
/// A coach mark highlights *several* elements on one dimmed overlay, so unlike
/// the tooltip / beacon / spotlight screens this one carries three anchors and
/// the campaign names all of them together.
///
/// The campaign lives in the SDK's hardcoded list (`MoETooltipController`) and
/// matches on the route name `CoachMarkDemo`, so this screen must be pushed with
/// `RouteSettings(name: 'CoachMarkDemo')` - see `main.dart`. Identity comes from
/// each widget's `ValueKey<String>`, which is what `ElementInspector` resolves.
///
/// The three targets are deliberately on **different rows**: native places every
/// card on the same side at the same `y` when targets share a row, and its
/// collision resolution then shifts them down one after another into a
/// staircase. Spreading them vertically lets placement pick different sides.
///
/// A coach mark cutout reveals the *real* widget rather than a copy of it, so
/// each target's `cutoutCornerRadius` in the campaign should match the radius
/// the widget is actually drawn with here - a square hole over the circular
/// search button would leave four background wedges.
class CoachMarkDemo extends StatelessWidget {
  const CoachMarkDemo({super.key});

  /// Ids the SDK's coach mark campaign names. Keep in sync with
  /// `MoETooltipController._coachMarkCampaigns`.
  static const String searchId = 'coach_search';
  static const String cartId = 'coach_cart';
  static const String profileId = 'coach_profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach Marks')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const Text(
            'Three targets, one overlay. The coach mark appears on entry once '
            'the route transition settles; tap the scrim to dismiss it.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          // Row 1 - circular, so the campaign uses a 28pt cutout radius to match.
          Align(
            alignment: Alignment.centerLeft,
            child: _target(
              key: const ValueKey<String>(searchId),
              label: 'Search',
              icon: Icons.search,
              color: Colors.orange,
              borderRadius: BorderRadius.circular(28),
              width: 56,
            ),
          ),
          const SizedBox(height: 72),
          // Row 2 - rounded rectangle, 12pt.
          Align(
            alignment: Alignment.centerRight,
            child: _target(
              key: const ValueKey<String>(cartId),
              label: 'Cart',
              icon: Icons.shopping_cart,
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              width: 96,
            ),
          ),
          const SizedBox(height: 72),
          // Row 3 - rounded rectangle, 12pt.
          Align(
            alignment: Alignment.centerLeft,
            child: _target(
              key: const ValueKey<String>(profileId),
              label: 'Profile',
              icon: Icons.person,
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(12),
              width: 96,
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Coach marks do not follow scroll: several cutouts and cards are '
            'placed together and native has no API to move them once shown.',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _target({
    required Key key,
    required String label,
    required IconData icon,
    required Color color,
    required BorderRadius borderRadius,
    required double width,
  }) {
    return Container(
      key: key,
      width: width,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: width > 60
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            )
          : Icon(icon, color: Colors.white),
    );
  }
}
