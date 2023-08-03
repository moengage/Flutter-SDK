import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import '../moengage_inbox_platform_interface.dart';

/// An implementation of [MoEngageInboxPlatform] that uses method channels.
class MethodChannelMoEngageInbox extends MoEngageInboxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

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
