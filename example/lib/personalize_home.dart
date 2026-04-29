// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'dart:convert';

import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> _offerings = [];

  List<String> _parseList(String input) =>
      input.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  List<ExperienceStatus> _parseStatuses(String input) {
    return _parseList(input)
        .map((s) => ExperienceStatus.fromString(s))
        .toList();
  }

  /// Extract ALL valid offerings from the campaign's payload. The offering key is
  /// dashboard-configurable, so we scan all entries. An entry may be either a stringified
  /// JSON array (server data_type "string") or an already-parsed list (data_type "json"),
  /// after the iOS plugin unwraps the {value, data_type} envelope. Android delivers the
  /// same shape via its native mapToAny(). Returns the full list — callers pass the array
  /// to offeringsShown(plural) and the first element to offeringShown / offeringClicked.
  List<Map<String, dynamic>> _extractOfferings(ExperienceCampaign campaign) {
    final result = <Map<String, dynamic>>[];
    for (final entry in campaign.payload.values) {
      List<dynamic>? offerings;
      if (entry is List) {
        offerings = entry;
      } else if (entry is String) {
        try {
          final decoded = json.decode(entry);
          if (decoded is List) {
            offerings = decoded;
          }
        } catch (_) {
          continue;
        }
      }
      if (offerings == null) continue;
      for (final offering in offerings) {
        if (offering is Map &&
            offering['offering_context'] is Map &&
            (offering['offering_context'] as Map).isNotEmpty) {
          result.add(Map<String, dynamic>.from(offering));
        }
      }
    }
    return result;
  }

  Future<void> _onFetchMeta() async {
    try {
      final statuses = _parseStatuses(_statusController.text);
      final result = await _personalize.fetchExperiencesMeta(statuses);
      debugPrint("_onFetchMeta(): Callback : $result");
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
      debugPrint("_onFetchExperiences(): Callback : $result");
      if (result.experiences.isNotEmpty) {
        final campaign = result.experiences.first;
        setState(() {
          _lastCampaign = campaign;
          _offerings = _extractOfferings(campaign);
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
    _showSnackBar('Experiences Shown: ${_lastCampaign!.experienceKey}');
  }

  void _onExperienceShown() {
    if (!_requireCampaign()) return;
    _personalize.experienceShown(_lastCampaign!);
    _showSnackBar('Experience Shown: ${_lastCampaign!.experienceKey}');
  }

  void _onExperienceClicked() {
    if (!_requireCampaign()) return;
    _personalize.experienceClicked(_lastCampaign!);
    _showSnackBar('Experience Clicked: ${_lastCampaign!.experienceKey}');
  }

  void _onOfferingsShown() {
    if (!_requireOfferings()) return;
    _personalize.offeringsShown(_offerings);
    _showSnackBar('Offerings Shown: ${_offerings.length}');
  }

  void _onOfferingShown() {
    if (!_requireOfferings()) return;
    _personalize.offeringShown(_offerings.first);
    _showSnackBar('Offering Shown');
  }

  void _onOfferingClicked() {
    if (!_requireCampaign()) return;
    if (!_requireOfferings()) return;
    _personalize.offeringClicked(_lastCampaign!, _offerings.first);
    _showSnackBar('Offering Clicked: ${_lastCampaign!.experienceKey}');
  }

  bool _requireCampaign() {
    if (_lastCampaign == null) {
      _showSnackBar('Run Fetch Experiences first to obtain a campaign');
      return false;
    }
    return true;
  }

  bool _requireOfferings() {
    if (_offerings.isEmpty) {
      _showSnackBar(
          'No offerings — fetch an experience with offerings');
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
              title: const Text('Experiences Shown (plural)'),
              onTap: _onExperiencesShown,
            ),
            ListTile(
              title: const Text('Experience Shown (singular)'),
              onTap: _onExperienceShown,
            ),
            ListTile(
              title: const Text('Experience Clicked'),
              onTap: _onExperienceClicked,
            ),
            ListTile(
              title: const Text('Offerings Shown (plural)'),
              onTap: _onOfferingsShown,
            ),
            ListTile(
              title: const Text('Offering Shown (singular)'),
              onTap: _onOfferingShown,
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
