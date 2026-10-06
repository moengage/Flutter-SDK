// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show CommonFailureReason, Logger;
import 'package:moengage_recommendations/moengage_recommendations.dart';

import 'constants.dart';

class RecommendationsHome extends StatefulWidget {
  const RecommendationsHome({super.key});

  @override
  State<RecommendationsHome> createState() => _RecommendationsHomeState();
}

class _RecommendationsHomeState extends State<RecommendationsHome> {
  final MoEngageRecommendations _recommendations =
      MoEngageRecommendations(WORKSPACE_ID);

  final TextEditingController _recommendationIdController =
      TextEditingController(text: '6ab61af414de69b70fe4819f');
  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _includedFieldsController =
      TextEditingController();

  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  String? _errorText;
  // True for an informational notice (e.g. the feature is disabled) rather than an actual
  // error — rendered as a neutral notice instead of a red error banner.
  bool _isQuietNotice = false;

  Set<String> _parseSet(String input) =>
      input.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toSet();

  Future<void> _onFetchRecommendations() async {
    final recommendationId = _recommendationIdController.text.trim();
    setState(() {
      _isLoading = true;
      _errorText = null;
      _isQuietNotice = false;
    });
    try {
      final RecommendedItems result =
          await _recommendations.fetchRecommendations(
        recommendationId,
        itemId: _itemIdController.text.trim(),
        includedFields: _parseSet(_includedFieldsController.text),
      );
      debugPrint('_onFetchRecommendations(): Result : $result');
      // An empty list is a success — there is simply nothing to recommend.
      setState(() {
        _items = result.items;
      });
    } on RecommendationsFailure catch (failure) {
      _handleRecommendationsFailure(failure);
    } catch (e) {
      Logger.e('RecommendationsHome _onFetchRecommendations(): $e');
      setState(() {
        _items = [];
        _errorText = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Dispatches on [failure.failureReason] — either a [RecommendationsFailureReason] (specific
  /// to this feature) or a [CommonFailureReason] (shared across every MoEngage SDK request) — and
  /// logs and renders each case appropriately rather than showing one generic error for all of
  /// them.
  void _handleRecommendationsFailure(RecommendationsFailure failure) {
    final reason = failure.failureReason;
    if (reason is RecommendationsFailureReason) {
      _handleSpecificFailure(reason, failure.message);
    } else if (reason is CommonFailureReason) {
      _handleCommonFailure(reason, failure.message);
    } else {
      // Unreachable today — RecommendationsFailureReason.fromString only ever returns one of the
      // two types above — but failureReason's declared type doesn't guarantee that, so fail safe
      // rather than crash the sample app.
      Logger.e('RecommendationsHome: Unmodelled failure reason type: $reason');
      setState(() {
        _items = [];
        _errorText = 'Something went wrong: ${failure.message}';
      });
    }
  }

  void _handleSpecificFailure(
      RecommendationsFailureReason reason, String message) {
    switch (reason) {
      case RecommendationsFailureReason.invalidRequest:
        // Dev-time bug — the recommendationId the user typed was rejected. Log loudly.
        Logger.e(
            'RecommendationsHome: Invalid recommendation request: $message');
        setState(() {
          _items = [];
          _errorText = 'Invalid request: $message';
        });

      case RecommendationsFailureReason.rateLimitExceeded:
        Logger.w('RecommendationsHome: Rate limit exceeded: $message');
        setState(() {
          _items = [];
          _errorText =
              'Too many requests — please wait a moment and try again.';
        });

      case RecommendationsFailureReason.payloadTooLarge:
      case RecommendationsFailureReason.internalServerError:
      case RecommendationsFailureReason.unknownError:
        Logger.e(
            'RecommendationsHome: Recommendations request failed ($reason): $message');
        setState(() {
          _items = [];
          _errorText =
              'Could not fetch recommendations right now. Please try again later.';
        });
    }
  }

  void _handleCommonFailure(CommonFailureReason reason, String message) {
    switch (reason) {
      case CommonFailureReason.networkError:
        Logger.w('RecommendationsHome: Network error: $message');
        setState(() {
          _items = [];
          _errorText =
              'You appear to be offline. Check your connection and try again.';
        });

      case CommonFailureReason.featureDisabled:
      case CommonFailureReason.sdkState:
        // Feature not available for this session — this isn't an error the user needs to act
        // on, so log it quietly and show a neutral notice rather than a red error banner.
        Logger.i(
            'RecommendationsHome: Recommendations unavailable ($reason): $message');
        setState(() {
          _items = [];
          _errorText = 'Recommendations aren\'t available right now.';
          _isQuietNotice = true;
        });

      case CommonFailureReason.serverError:
      case CommonFailureReason.parseError:
      case CommonFailureReason.invalidParameters:
      case CommonFailureReason.invalidInitialisationConfiguration:
      case CommonFailureReason.duplicateFunctionCall:
      case CommonFailureReason.authenticationFailed:
      case CommonFailureReason.unknownError:
        Logger.e(
            'RecommendationsHome: Recommendations request failed ($reason): $message');
        setState(() {
          _items = [];
          _errorText =
              'Could not fetch recommendations right now. Please try again later.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations')),
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
                    controller: _recommendationIdController,
                    decoration: const InputDecoration(
                      labelText: 'Recommendation ID',
                      hintText: 'clothing',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _itemIdController,
                    decoration: const InputDecoration(
                      labelText: 'Item ID (optional)',
                      hintText: 'shirts',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _includedFieldsController,
                    decoration: const InputDecoration(
                      labelText: 'Included Fields (optional)',
                      hintText: 'size,color',
                      helperText: 'Comma-separated',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _onFetchRecommendations,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                          _isLoading ? 'Fetching…' : 'Fetch Recommendations'),
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
              color: _isQuietNotice
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _isQuietNotice ? Icons.info_outline : Icons.error_outline,
                      color: _isQuietNotice
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: TextStyle(
                          color: _isQuietNotice
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_items.isEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No results yet — fetch recommendations to see items here.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.hintColor),
                ),
              ),
            )
          else if (_items.isNotEmpty)
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Results (${_items.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  ...ListTile.divideTiles(
                    context: context,
                    tiles: _items.map(_buildItemTile),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemTile(Map<String, dynamic> item) {
    final productId = item['product_id']?.toString();
    final otherFields = Map<String, dynamic>.from(item)..remove('product_id');
    return ListTile(
      title: Text(productId ?? item.toString()),
      subtitle: otherFields.isEmpty
          ? null
          : Text(otherFields.entries
              .map((e) => '${e.key}: ${e.value}')
              .join(' · ')),
    );
  }

  @override
  void dispose() {
    _recommendationIdController.dispose();
    _itemIdController.dispose();
    _includedFieldsController.dispose();
    super.dispose();
  }
}
