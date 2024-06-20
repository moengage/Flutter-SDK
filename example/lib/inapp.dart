import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

import '../constants.dart';
import 'utils.dart';

/// InApp Screen
class InAppHomeScreen extends StatefulWidget {
  const InAppHomeScreen({super.key});

  @override
  State<InAppHomeScreen> createState() => _InAppHomeScreenState();
}

class _InAppHomeScreenState extends State<InAppHomeScreen> {
  final MoEngageFlutter _moengagePlugin =
      MoEngageFlutter(APP_ID);

  static const String tag = 'InAppHomeScreen';

  @override
  void initState() {
    super.initState();
    _moengagePlugin.setInAppClickHandler(_onInAppClick);
    _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
    _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
    _moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandle);
  }

  void _onInAppClick(ClickData message) {
    debugPrint(
        '$tag Main : _onInAppClick() : This is a inapp click callback from native to flutter. Payload $message');
  }

  void _onInAppShown(InAppData message) {
    debugPrint(
        '$tag Main : _onInAppShown() : This is a callback on inapp shown from native to flutter. Payload $message');
  }

  void _onInAppDismiss(InAppData message) {
    debugPrint(
        '$tag Main : _onInAppDismiss() : This is a callback on inapp dismiss from native to flutter. Payload $message');
  }

  Future<void> _onInAppSelfHandle(SelfHandledCampaignData? message) async {
    if (message == null) {
      debugPrint('$tag _onInAppSelfHandle(): SelfHandled InApp Data is Null');
      return;
    }
    debugPrint(
        '$tag Main : _onInAppSelfHandle() : This is a callback on inapp self handle from native to flutter. Payload $message');
    final SelfHandledActions? action = await asyncSelfHandledDialog(context);
    switch (action) {
      case SelfHandledActions.Shown:
        _moengagePlugin.selfHandledShown(message);
        break;
      case SelfHandledActions.Clicked:
        _moengagePlugin.selfHandledClicked(message);
        break;
      case SelfHandledActions.Dismissed:
        _moengagePlugin.selfHandledDismissed(message);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('InApp Home'),
        ),
        body: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
          ListTile(
            title: const Text('Show InApp'),
            onTap: () {
              _moengagePlugin.showInApp();
            },
          ),
          ListTile(
            title: const Text('Show Nudge'),
            onTap: () {
              _moengagePlugin.showNudge();
            },
          ),
          ListTile(
            title: const Text('Show Nudge Top'),
            onTap: () {
              _moengagePlugin.showNudge(position: MoEngageNudgePosition.top);
            },
          ),
          ListTile(
            title: const Text('Show Nudge Bottom'),
            onTap: () {
              _moengagePlugin.showNudge(position: MoEngageNudgePosition.bottom);
            },
          ),
          ListTile(
            title: const Text('Show Nudge Bottom Left'),
            onTap: () {
              _moengagePlugin.showNudge(
                  position: MoEngageNudgePosition.bottomLeft);
            },
          ),
          ListTile(
            title: const Text('Show Nudge Bottom Right'),
            onTap: () {
              _moengagePlugin.showNudge(
                  position: MoEngageNudgePosition.bottomRight);
            },
          ),
          ListTile(
            title: const Text('Show Max Nudge'),
            onTap: () {
              _moengagePlugin.showNudge();
              _moengagePlugin.showNudge();
              _moengagePlugin.showNudge();
            },
          ),
          ListTile(
            title: const Text('Show Nudge + InApp'),
            onTap: () {
              _moengagePlugin.showNudge();
              _moengagePlugin.showInApp();
            },
          ),
          ListTile(
            title: const Text('Show Max Nudge + InApp'),
            onTap: () {
              _moengagePlugin.showNudge();
              _moengagePlugin.showNudge();
              _moengagePlugin.showNudge();
              _moengagePlugin.showInApp();
            },
          ),
          ListTile(
            title: const Text('Show Self handled InApp'),
            onTap: () {
              _moengagePlugin.getSelfHandledInApp();
            },
          ),
        ]).toList()));
  }
}
