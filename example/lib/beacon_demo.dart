// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

import 'constants.dart';

/// Beacon demo, mirroring the native iOS test app's beacon screen: three anchor
/// targets in a row, and a dot that appears on the chosen one's top-right corner.
///
/// The beacon here is a **dot only** - an expanding ripple on the element's
/// corner, no card. Tapping the dot does still expand it into a card, which is
/// native behaviour that cannot currently be switched off.
///
/// Targets are wrapped in `MoEngageView`, so the SDK resolves them by a direct
/// lookup and enforces its visibility rule. The dot's corner, animation and size
/// are **fixed in the iOS bridge** (`MoEngageFlutterBeaconRenderer`) - the element
/// payload carries only bounds, a message and the overlay type, so there is
/// nowhere to send styling from Dart yet. Edit the renderer to try other looks.
class BeaconDemo extends StatefulWidget {
  const BeaconDemo({super.key});

  @override
  State<BeaconDemo> createState() => _BeaconDemoState();
}

class _BeaconDemoState extends State<BeaconDemo> {
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter(WORKSPACE_ID);

  static const List<_Anchor> _anchors = <_Anchor>[
    _Anchor(id: 'beacon_alerts', label: 'Alerts', icon: Icons.notifications),
    _Anchor(id: 'beacon_cart', label: 'Cart', icon: Icons.shopping_cart),
    _Anchor(id: 'beacon_profile', label: 'Profile', icon: Icons.person),
  ];

  String _selectedId = _anchors.first.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(title: const Text('Beacon Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            'Pick an anchor below, then Show Beacon. A ripple dot appears on '
            'that element\'s top-right corner.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          _card(
            title: 'Anchor targets',
            child: Row(
              children: <Widget>[
                for (final _Anchor anchor in _anchors)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      // The wrapper is the whole per-element integration: it
                      // registers this widget with the SDK while it is mounted.
                      child: MoEngageView(
                        id: anchor.id,
                        child: _targetButton(anchor),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            title: 'Anchor',
            child: Wrap(
              spacing: 8,
              children: <Widget>[
                for (final _Anchor anchor in _anchors)
                  ChoiceChip(
                    label: Text(anchor.label),
                    selected: _selectedId == anchor.id,
                    onSelected: (bool _) =>
                        setState(() => _selectedId = anchor.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _showBeacon,
              child: const Text('Show Beacon'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _moengagePlugin.dismissElementSpotlight,
            child: const Text('Dismiss'),
          ),
          const SizedBox(height: 8),
          _card(
            title: 'Scenarios',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Beacon on an unregistered id'),
                  subtitle: const Text('Refused and logged; nothing shows.'),
                  onTap: () => _report(_moengagePlugin.showBeaconOnElement(
                    elementId: 'not_registered',
                    message: 'Never appears.',
                  )),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('What is registered right now?'),
                  onTap: () => _toast(
                      _moengagePlugin.registeredElementIds.join(', ')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBeacon() {
    final _Anchor anchor =
        _anchors.firstWhere((_Anchor a) => a.id == _selectedId);
    _report(_moengagePlugin.showBeaconOnElement(
      elementId: anchor.id,
      message: 'This beacon is anchored to the ${anchor.label} element. '
          'Tap the dot to learn more.',
    ));
  }

  void _report(bool shown) {
    if (!shown) {
      _toast('Not shown - see the log for why');
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  Widget _targetButton(_Anchor anchor) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF3478F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(anchor.icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              anchor.label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Anchor {
  const _Anchor({required this.id, required this.label, required this.icon});

  final String id;
  final String label;
  final IconData icon;
}
