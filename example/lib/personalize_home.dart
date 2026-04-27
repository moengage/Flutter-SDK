// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_personalize/moengage_personalize.dart';

import 'constants.dart';

class PersonalizeHome extends StatefulWidget {
  const PersonalizeHome({super.key});

  @override
  State<PersonalizeHome> createState() => _PersonalizeHomeState();
}

class _PersonalizeHomeState extends State<PersonalizeHome> {
  final MoEngagePersonalize _personalize =
      MoEngagePersonalize(WORKSPACE_ID);

  final TextEditingController _statusController =
      TextEditingController(text: 'active');
  final TextEditingController _keysController = TextEditingController();

  ExperienceCampaign? _lastCampaign;
  Map<String, dynamic>? _offeringPayload;

  List<String> _parseList(String input) =>
      input.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  List<ExperienceStatus> _parseStatuses(String input) {
    return _parseList(input)
        .map((s) => ExperienceStatus.fromString(s))
        .toList();
  }

  /// Extract the full offering dict from campaign payload, returns null if unavailable.
  Map<String, dynamic>? _extractOfferingPayload(ExperienceCampaign campaign) {
    try {
      final offeringsRaw = campaign.payload['offerings'];
      if (offeringsRaw is String) {
        final offerings = json.decode(offeringsRaw);
        if (offerings is List && offerings.isNotEmpty) {
          final offering = offerings[0];
          if (offering is Map<String, dynamic> && offering.isNotEmpty) {
            return offering.cast<String, dynamic>();
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _onFetchMeta() async {
    try {
      final statuses = _parseStatuses(_statusController.text);
      final result = await _personalize.fetchExperiencesMeta(statuses);
      Logger.d("$tag _onFetchMeta(): Callback : $result");
      final lines = result.experiences
          .map((e) => '- ${e.experienceKey} (${e.status.value})')
          .join('\n');
      _showResultDialog(
        'Fetch Meta',
        'source: ${result.source.value}\n'
            'count: ${result.experiences.length}\n'
            '$lines',
      );
    } on PersonalizeError catch (e) {
      _showError(e);
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _onFetchExperiences() async {
    final keys = _parseList(_keysController.text);
    if (keys.isEmpty) {
      _showSnackBar('Enter at least one experience key');
      return;
    }
    try {
      final result = await _personalize.fetchExperiences(keys);
      Logger.d("$tag _onFetchExperiences(): Callback : $result");
      if (result.experiences.isNotEmpty) {
        final campaign = result.experiences.first;
        setState(() {
          _lastCampaign = campaign;
          _offeringPayload = _extractOfferingPayload(campaign);
        });
      }
      final expLines = result.experiences
          .map((e) => '- ${e.experienceKey} [${e.source.value}]')
          .join('\n');
      final failLines = result.failures
          .map((f) => '- ${f.reason}: ${f.experienceKeys.join(', ')}')
          .join('\n');
      _showResultDialog(
        'Fetch Experiences',
        'experiences (${result.experiences.length}):\n${expLines.isEmpty ? '(none)' : expLines}\n\n'
            'failures (${result.failures.length}):\n${failLines.isEmpty ? '(none)' : failLines}',
      );
    } on PersonalizeError catch (e) {
      _showError(e);
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _onExperiencesShown() {
    if (!_requireCampaign()) return;
    _personalize.experiencesShown([_lastCampaign!]);
    _showSnackBar('Experience Shown: ${_lastCampaign!.experienceKey}');
  }

  void _onExperienceClicked() {
    if (!_requireCampaign()) return;
    _personalize.experienceClicked(_lastCampaign!);
    _showSnackBar('Experience Clicked: ${_lastCampaign!.experienceKey}');
  }

  void _onOfferingsShown() {
    if (!_requireOfferingPayload()) return;
    _personalize.offeringsShown([_offeringPayload!]);
    _showSnackBar('Offering Shown');
  }

  void _onOfferingClicked() {
    if (!_requireCampaign()) return;
    if (!_requireOfferingPayload()) return;
    _personalize.offeringClicked(_lastCampaign!, _offeringPayload!);
    _showSnackBar('Offering Clicked: ${_lastCampaign!.experienceKey}');
  }

  bool _requireCampaign() {
    if (_lastCampaign == null) {
      _showSnackBar('Run Fetch Experiences first to obtain a campaign');
      return false;
    }
    return true;
  }

  bool _requireOfferingPayload() {
    if (_offeringPayload == null) {
      _showSnackBar(
          'No offering payload — fetch an experience with offerings');
      return false;
    }
    return true;
  }

  void _showError(PersonalizeError e) {
    _showSnackBar('${e.code}: ${e.message}');
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 3),
    ));
  }

  void _showResultDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personalize')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Statuses (comma-separated)',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TextField(
            controller: _statusController,
            decoration: const InputDecoration(
              hintText: 'active,paused,scheduled',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Experience Keys (comma-separated)',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TextField(
            controller: _keysController,
            decoration: const InputDecoration(
              hintText: 'welcome_banner,home_hero',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          ...ListTile.divideTiles(context: context, tiles: [
            ListTile(
              title: const Text('Fetch Experience Meta'),
              onTap: _onFetchMeta,
            ),
            ListTile(
              title: const Text('Fetch Experiences'),
              onTap: _onFetchExperiences,
            ),
            ListTile(
              title: const Text('Experience Shown'),
              onTap: _onExperiencesShown,
            ),
            ListTile(
              title: const Text('Experience Clicked'),
              onTap: _onExperienceClicked,
            ),
            ListTile(
              title: const Text('Offering Shown'),
              onTap: _onOfferingsShown,
            ),
            ListTile(
              title: const Text('Offering Clicked'),
              onTap: _onOfferingClicked,
            ),
          ]),
          if (_lastCampaign != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Last campaign: ${_lastCampaign!.experienceKey}',
                style: const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _statusController.dispose();
    _keysController.dispose();
    super.dispose();
  }
}
