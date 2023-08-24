import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';

/// The Android implementation of [MoEngageInboxPlatform].
class MoEngageInboxAndroid extends MoEngageInboxPlatform {
  final MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  /// Registers this class as the default instance of [MoEngageInboxPlatform]
  static void registerWith() {
    Logger.v('Registering MoEngageInboxAndroid with Platform Interface');
    MoEngageInboxPlatform.instance = MoEngageInboxAndroid();
  }

  @override
  Future<int> getUnClickedCount(String appId) async {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    final dynamic unClickedCountPayload = await _channel.invokeMethod(
        METHOD_NAME_UN_CLICKED_COUNT, json.encode(payload));
    return fetchUnclickedCount(unClickedCountPayload);
  }

  @override
  void trackMessageClicked(InboxMessage message, String appId) {
    final Map<String, dynamic> payload = getImpressionPayload(message, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_CLICKED, json.encode(payload));
  }

  @override
  void deleteMessage(InboxMessage message, String appId) {
    final Map<String, dynamic> payload = getImpressionPayload(message, appId);
    _channel.invokeMethod(METHOD_NAME_DELETE_MESSAGE, json.encode(payload));
  }

  @override
  Future<InboxData?> fetchAllMessages(String appId) async {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    final serialisedMessages = await _channel.invokeMethod(
        METHOD_NAME_FETCH_MESSAGES, json.encode(payload));
    return deSerializeInboxMessages(serialisedMessages.toString());
  }
}
