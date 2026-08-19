// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

import 'constants.dart';

/// Demonstrates the `MoEngageView` wrapper, scoped to the **spotlight** overlay.
///
/// How this differs from the other overlay screens in this app:
///
///  * **Identity comes from the wrapper, not a `ValueKey`.** `MoEngageView(id:)`
///    registers its render object with the SDK when it mounts, so resolving an
///    id is a map lookup. The other screens rely on `ValueKey<String>` and the
///    SDK searches the widget tree for it.
///  * **The app triggers it.** The other screens wait for a hardcoded campaign to
///    match the route name on entry; here you tap a button, so you can retrigger
///    and watch the visibility rule reject a half-scrolled target.
///  * **Visibility is enforced.** `showSpotlightOnElement` refuses to anchor
///    unless the element is fully on screen - a cutout around a partly-scrolled
///    row would sit over whatever is clipping it. The `ValueKey` path has no such
///    check.
///
/// This screen needs neither `MoEDesignModeWrapper` nor a named route.
/// `MoENavigationObserver` **is** still required, though: the registry has no
/// dismissal logic of its own, so the observer's route-change dismiss - which
/// closes every element overlay natively - is what stops the spotlight lingering
/// over the next screen.
class MoEViewSpotlightDemo extends StatefulWidget {
  const MoEViewSpotlightDemo({super.key});

  @override
  State<MoEViewSpotlightDemo> createState() => _MoEViewSpotlightDemoState();
}

class _MoEViewSpotlightDemoState extends State<MoEViewSpotlightDemo> {
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter(WORKSPACE_ID);

  /// Ids the wrapper registers. Each must be unique across the app.
  static const String _pinnedId = 'moeview_pinned';
  static const String _scrollingId = 'moeview_scrolling';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoEngageView + Spotlight')),
      body: Column(
        children: <Widget>[
          // Pinned outside the scrollable, so it is always fully visible and the
          // happy path always works.
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MoEngageView(
                  id: _pinnedId,
                  child: _target(
                    label: 'Pinned',
                    color: Colors.deepPurple,
                    icon: Icons.push_pin,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: <Widget>[
                _header('Spotlight the pinned target'),
                ListTile(
                  title: const Text('Spotlight it'),
                  subtitle: const Text('Always fully visible, so this works.'),
                  onTap: () => _spotlight(_pinnedId, 'Anchored via MoEngageView.'),
                ),
                const Divider(height: 1),
                _header('The visibility rule'),
                ListTile(
                  title: const Text('Spotlight the scrolling target below'),
                  subtitle: const Text(
                      'Scroll it half off screen, then tap: the SDK refuses to '
                      'anchor. Bring it fully into view and tap again.'),
                  onTap: () => _spotlight(
                      _scrollingId, 'This one had to be fully on screen.'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: MoEngageView(
                      id: _scrollingId,
                      child: _target(
                        label: 'Scrolls',
                        color: Colors.teal,
                        icon: Icons.swap_vert,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                _header('Diagnostics'),
                ListTile(
                  title: const Text('How visible is each target?'),
                  onTap: _reportVisibility,
                ),
                ListTile(
                  title: const Text('What is registered right now?'),
                  subtitle: const Text(
                      'Scroll the target out of the list and check again - the '
                      'wrapper unregisters when it leaves the tree.'),
                  onTap: _reportRegistered,
                ),
                ListTile(
                  title: const Text('Spotlight an id nobody registered'),
                  subtitle: const Text('Returns false and logs; nothing shows.'),
                  onTap: () => _spotlight('not_registered', 'Never appears.'),
                ),
                ListTile(
                  title: const Text('Dismiss the spotlight'),
                  onTap: _moengagePlugin.dismissElementSpotlight,
                ),
                // Filler so the scrolling target can actually be moved around.
                for (int i = 1; i <= 20; i++)
                  ListTile(dense: true, title: Text('Filler row $i')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _spotlight(String id, String message) {
    final bool shown = _moengagePlugin.showSpotlightOnElement(
      elementId: id,
      message: message,
    );
    if (!shown) {
      final double? fraction = _moengagePlugin.elementVisibleFraction(id);
      _toast(fraction == null
          ? '"$id" is not registered'
          : '"$id" is only ${(fraction * 100).round()}% on screen');
    }
  }

  void _reportVisibility() {
    final double? pinned = _moengagePlugin.elementVisibleFraction(_pinnedId);
    final double? scrolling =
        _moengagePlugin.elementVisibleFraction(_scrollingId);
    _toast('pinned: ${_percent(pinned)}, scrolling: ${_percent(scrolling)}');
  }

  void _reportRegistered() {
    final List<String> ids = _moengagePlugin.registeredElementIds;
    _toast(ids.isEmpty ? 'nothing registered' : ids.join(', '));
  }

  String _percent(double? fraction) =>
      fraction == null ? 'not registered' : '${(fraction * 100).round()}%';

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  Widget _header(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      );

  Widget _target({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 120,
      height: 56,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
