// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter_example/constants.dart';

/// Demonstrates fetching a JWT from the IAM endpoint and passing it to the
/// native MoEngage SDK via [MoEngageFlutter.passAuthenticationDetails].
class JwtAuthenticationPage extends StatefulWidget {
  const JwtAuthenticationPage({super.key, required this.moengagePlugin});

  final MoEngageFlutter moengagePlugin;

  @override
  State<JwtAuthenticationPage> createState() => _JwtAuthenticationPageState();
}

class _JwtAuthenticationPageState extends State<JwtAuthenticationPage> {
  final TextEditingController _userIdentifierController =
      TextEditingController();
  final TextEditingController _expirySecondsController =
      TextEditingController(text: '2600');
  final TextEditingController _manualTokenController = TextEditingController();

  bool _loading = false;
  String _errorMessage = '';
  String _fetchedToken = '';

  @override
  void dispose() {
    _userIdentifierController.dispose();
    _expirySecondsController.dispose();
    _manualTokenController.dispose();
    super.dispose();
  }

  int _parseExpirySeconds() {
    final int? n = int.tryParse(_expirySecondsController.text.trim());
    return (n != null && n > 0) ? n : 2600;
  }

  String? _extractJwtTokenFromIamResponse(dynamic json) {
    if (json is! Map) {
      return null;
    }
    final dynamic data = json['data'];
    if (data is Map && data['jwt_token'] is String) {
      return data['jwt_token'] as String;
    }
    if (json['jwt_token'] is String) {
      return json['jwt_token'] as String;
    }
    return null;
  }

  Future<void> _fetchTokenFromIam() async {
    setState(() {
      _errorMessage = '';
      _fetchedToken = '';
    });

    final String uid = _userIdentifierController.text.trim();
    if (uid.isEmpty) {
      setState(() => _errorMessage = 'Enter a user id / email.');
      return;
    }

    setState(() => _loading = true);
    try {
      final HttpClient client = HttpClient();
      final HttpClientRequest request =
          await client.postUrl(Uri.parse(IAM_JWT_TOKEN_URL));
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('MOE-APPKEY', WORKSPACE_ID);
      request.write(jsonEncode(<String, dynamic>{
        'expireAfterSeconds': _parseExpirySeconds(),
        'payload': <String, String>{
          'key': IAM_PAYLOAD_UID_KEY,
          'value': uid,
        },
      }));

      final HttpClientResponse response = await request.close();
      final String rawText = await response.transform(utf8.decoder).join();
      client.close();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        setState(
            () => _errorMessage = 'HTTP ${response.statusCode}\n${rawText}');
        return;
      }

      dynamic json;
      try {
        json = jsonDecode(rawText);
      } catch (_) {
        setState(() => _errorMessage =
            'HTTP ${response.statusCode}. Response was not JSON.\n$rawText');
        return;
      }

      final String? token = _extractJwtTokenFromIamResponse(json);
      if (token == null) {
        setState(() =>
            _errorMessage = 'Could not find jwt_token in response.\n$rawText');
        return;
      }

      setState(() => _fetchedToken = token);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  String _effectiveToken() {
    final String manual = _manualTokenController.text.trim();
    if (manual.isNotEmpty) {
      return manual;
    }
    return _fetchedToken.trim();
  }

  bool _canPassToSdk() {
    return _userIdentifierController.text.trim().isNotEmpty &&
        _effectiveToken().isNotEmpty;
  }

  Future<void> _passToNativeSdk() async {
    final String userIdentifier = _userIdentifierController.text.trim();
    final String token = _effectiveToken();

    if (userIdentifier.isEmpty || token.isEmpty) {
      await _showAlert('Missing data',
          'Enter user id and either fetch a token from IAM or paste one manually.');
      return;
    }

    try {
      widget.moengagePlugin.passAuthenticationDetails(
          AuthenticationDetailsRequest(
              authenticationType: AuthenticationType.jwt,
              data: JwtAuthenticationData(
                  token: token, userIdentifier: userIdentifier)));
      await _showAlert(
          'Done', 'passAuthenticationDetails was sent to the native SDK.');
    } catch (e) {
      await _showAlert('Error', e.toString());
    }
  }

  Future<void> _showAlert(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JWT (IAM)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Workspace id (MOE-APPKEY): $WORKSPACE_ID',
                style: Theme.of(context).textTheme.bodySmall),
            Text('POST $IAM_JWT_TOKEN_URL',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            TextField(
              controller: _userIdentifierController,
              decoration: const InputDecoration(
                labelText: 'User id / email (payload.value)',
                hintText: 'e.g. user@example.com',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _expirySecondsController,
              decoration: const InputDecoration(
                labelText: 'Expiry (seconds)',
                hintText: '2600',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _fetchTokenFromIam,
              child: Text(_loading ? 'Fetching…' : 'Fetch token from IAM'),
            ),
            if (_errorMessage.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(_errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            if (_fetchedToken.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Token received',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Review below, then pass to the native SDK.'),
                      const SizedBox(height: 8),
                      const Text('jwt_token',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SelectableText(_fetchedToken,
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _manualTokenController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Or paste a token manually (optional)',
                hintText:
                    'Skip IAM fetch and paste a JWT from Postman / your server',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _canPassToSdk() ? _passToNativeSdk : null,
              child: const Text('Pass authentication details to native SDK'),
            ),
            const SizedBox(height: 8),
            Text(
              'Uses passAuthenticationDetails with the token shown above, or the manual field if filled.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
