// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'utils.dart';

/// InApp Screen
class InAppHomeScreen extends StatefulWidget {
  const InAppHomeScreen({super.key});

  @override
  State<InAppHomeScreen> createState() => _InAppHomeScreenState();
}

class _InAppHomeScreenState extends State<InAppHomeScreen> {
  final MoEngageFlutter _moengagePlugin =
      MoEngageFlutter('CM4D1LZN2IMJNBY9ULXAU73D');

  static const String tag = 'InAppHomeScreen';

  @override
  void initState() {
    super.initState();
    _moengagePlugin.setCurrentContext(['ak5','ak1','ak2']);
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
    await handleAction(context,message);
  }

  Future<void> handleAction(BuildContext context, SelfHandledCampaignData message) async {
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
    }}

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
          ListTile(
            title: const Text('Get Self handled InApps'),
            onTap: () {
              _moengagePlugin.getSelfHandledInApps().then((campaignsData) {
                _showBottomSheet(campaignsData, context);
              });
            },
          ),
        ]).toList()));
  }

  void _showBottomSheet(SelfHandledCampaignsData campaignsData, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: campaignsData.campaigns.length,
          itemBuilder: (BuildContext context, int index) {
            final campaign = campaignsData.campaigns[index];
            return ListTile(
              title: ExpandableText(text:campaign.campaign.payload), // Customize as needed
              trailing: ElevatedButton(
                onPressed: () async{
                  await handleAction(context,campaign);
                },
                child: const Text('Action'),
              ),
            );
          },
        );
      },
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 4});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        TextButton(
          onPressed: _toggleExpand,
          child: Text(_isExpanded ? 'Collapse' : 'Expand'),
        ),
      ],
    );
  }
}
