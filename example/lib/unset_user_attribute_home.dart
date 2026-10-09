// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

import 'constants.dart';

final MoEngageFlutter _moengagePlugin = MoEngageFlutter(WORKSPACE_ID);

class UnsetUserAttributeHome extends StatefulWidget {
  const UnsetUserAttributeHome({super.key});

  @override
  State<UnsetUserAttributeHome> createState() =>
      _UnsetUserAttributeHomeState();
}

class _UnsetUserAttributeHomeState extends State<UnsetUserAttributeHome> {
  final TextEditingController _attributeNameController =
      TextEditingController(text: 'test_attribute');

  UserAttributeLevel _attributeLevel = UserAttributeLevel.project;
  bool _isLoading = false;
  String? _resultText;
  String? _errorText;

  Future<void> _onUnsetAttribute() async {
    final attributeName = _attributeNameController.text.trim();
    setState(() {
      _isLoading = true;
      _resultText = null;
      _errorText = null;
    });
    try {
      final UnsetUserAttributeResult result =
          await _moengagePlugin.unsetUserAttribute(
        attributeName,
        attributeLevel: _attributeLevel,
      );
      debugPrint('_onUnsetAttribute(): Result : $result');
      setState(() {
        _resultText = 'Removed "${result.attributeName}" at '
            '${result.attributeLevel.value} level.';
      });
    } on UnsetUserAttributeFailure catch (failure) {
      Logger.e(
          'UnsetUserAttributeHome: unsetUserAttribute failed (${failure.failureReason}): ${failure.message}');
      setState(() {
        _errorText = '${failure.failureReason}: ${failure.message}';
      });
    } catch (e) {
      Logger.e('UnsetUserAttributeHome _onUnsetAttribute(): $e');
      setState(() {
        _errorText = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Unset User Attribute')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Request', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _attributeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Attribute Name',
                      hintText: 'test_attribute',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<UserAttributeLevel>(
                    initialValue: _attributeLevel,
                    decoration: const InputDecoration(
                      labelText: 'Attribute Level',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: UserAttributeLevel.values
                        .map((level) => DropdownMenuItem(
                              value: level,
                              child: Text(level.value),
                            ))
                        .toList(),
                    onChanged: (level) {
                      if (level != null) {
                        setState(() => _attributeLevel = level);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _onUnsetAttribute,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.remove_circle_outline),
                      label:
                          Text(_isLoading ? 'Removing…' : 'Unset Attribute'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_errorText != null)
            Card(
              margin: EdgeInsets.zero,
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style:
                            TextStyle(color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_resultText != null)
            Card(
              margin: EdgeInsets.zero,
              color: theme.colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: theme.colorScheme.onSecondaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _resultText!,
                        style: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _attributeNameController.dispose();
    super.dispose();
  }
}
