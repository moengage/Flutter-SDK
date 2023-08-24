import 'dart:core';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';

/// IOS implementation of [MoEngageInboxPlatform].
class MoEngageInboxIOS extends MoEngageInboxPlatform {
  /// [MoEngageInboxIOS] Constructor
  MoEngageInboxIOS();
  final MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  /// Registers this class as the default instance of [MoEngageInboxPlatform]
  static void registerWith() {
    Logger.v('Registering MoEngageInboxIOS with Platform Interface');
    MoEngageInboxPlatform.instance = MoEngageInboxIOS();
  }

  @override
  Future<int> getUnClickedCount(String appId) async {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    final unClickedCountPayload =
        await _channel.invokeMethod(METHOD_NAME_UN_CLICKED_COUNT, payload);
    return fetchUnclickedCount(unClickedCountPayload);
  }

  @override
  void trackMessageClicked(InboxMessage message, String appId) {
    final Map<String, dynamic> payload = getImpressionPayload(message, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_CLICKED, payload);
  }

  @override
  void deleteMessage(InboxMessage message, String appId) {
    final Map<String, dynamic> payload = getImpressionPayload(message, appId);
    _channel.invokeMethod(METHOD_NAME_DELETE_MESSAGE, payload);
  }

  @override
  Future<InboxData?> fetchAllMessages(String appId) async {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    final serialisedMessages =
        await _channel.invokeMethod(METHOD_NAME_FETCH_MESSAGES, payload);
    return deSerializeInboxMessages(serialisedMessages);
  }
}
