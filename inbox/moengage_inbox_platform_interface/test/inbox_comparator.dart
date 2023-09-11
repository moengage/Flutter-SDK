import 'package:collection/collection.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show AccountMeta;
import 'package:moengage_inbox_platform_interface/moengage_inbox_platform_interface.dart';

class InboxComparator {
  bool isInboxDataEqual(InboxData? data1, InboxData? data2) {
    return data1?.platform == data2?.platform &&
        isInboxMessagesEqual(data1?.messages ?? <InboxMessage>[],
            data2?.messages ?? <InboxMessage>[]);
  }

  bool isAccountMetaEqual(AccountMeta? data1, AccountMeta? data2) {
    return data1?.appId == data2?.appId;
  }

  bool isInboxMessageEqual(InboxMessage data1, InboxMessage data2) {
    return data1.isClicked == data1.isClicked &&
        data1.campaignId == data2.campaignId &&
        const DeepCollectionEquality().equals(data1.payload, data2.payload) &&
        data1.expiry == data2.expiry &&
        data1.id == data2.id &&
        isInboxActionsEqual(data1.action, data2.action) &&
        data1.campaignId == data2.campaignId &&
        isMediaEqual(data1.media, data2.media) &&
        data1.receivedTime == data2.receivedTime &&
        data1.tag == data2.tag &&
        isTextContentEqual(data1.textContent, data2.textContent);
  }

  bool isInboxMessagesEqual(
      List<InboxMessage> data1, List<InboxMessage> data2) {
    if (data1.length != data2.length) {
      return false;
    }
    for (int i = 0; i < data1.length; i++) {
      if (!isInboxMessageEqual(data1[i], data2[i])) {
        return false;
      }
    }
    return true;
  }

  bool isMediaEqual(Media? data1, Media? data2) {
    return data1?.mediaType == data2?.mediaType && data1?.url == data2?.url;
  }

  bool isTextContentEqual(TextContent? data1, TextContent? data2) {
    return data1?.title == data2?.title &&
        data1?.subtitle == data2?.subtitle &&
        data1?.message == data2?.message &&
        data1?.summary == data2?.summary;
  }

  bool isInboxActionsEqual(List<Action> data1, List<Action> data2) {
    if (data1.length != data2.length) {
      return false;
    }
    for (int i = 0; i < data1.length; i++) {
      if (!isActionEqual(data1[i], data2[i])) {
        return false;
      }
    }
    return true;
  }

  bool isActionEqual(Action? action1, Action? action2) {
    return action1?.actionType == action2?.actionType;
  }
}
