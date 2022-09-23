import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:moengage_inbox/action.dart';
import 'package:moengage_inbox/action_type.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/inbox_message.dart';
import 'package:moengage_inbox/media.dart';
import 'package:moengage_inbox/media_type.dart';
import 'package:moengage_inbox/navigation_action.dart';
import 'package:moengage_inbox/navigation_type.dart';
import 'package:moengage_inbox/text_content.dart';
import 'package:moengage_inbox/constants.dart';

// Unclicked Count
int fetchUnclickedCount(dynamic unClickedPayload) {
  Map<String, dynamic> payload = json.decode(unClickedPayload);
  Map<String, dynamic> dataPayload = payload[keyData];
  if (dataPayload.isNotEmpty) {
    int unclickedCount = dataPayload.containsKey(keyUnClickedCount)
        ? dataPayload[keyUnClickedCount]
        : 0;
    return unclickedCount;
  }

  return 0;
}

Map<String, dynamic> messageToMap(InboxMessage inboxMessage) {
  Map<String, dynamic> message = {
    keyId: inboxMessage.id,
    keyCampaignId: inboxMessage.campaignId,
    keyIsClicked: inboxMessage.isClicked,
    keyReceivedTime: inboxMessage.receivedTime,
    keyExpiryTime: inboxMessage.expiry,
    keyPayload: inboxMessage.payload,
    keyTextContent: mapFromTextContent(inboxMessage.textContent),
    keyAction: actionsListFromModel(inboxMessage.action)
  };
  Media? media = inboxMessage.media;
  if (media != null) {
    message[keyMediaContent] = mapFromMedia(media);
  }
  return message;
}

InboxData? deSerializeInboxMessages(dynamic messagesPayload) {
  try {
    Map<String, dynamic> message = json.decode(messagesPayload);
    Map<String, dynamic> dataPayload = message[keyData];
    return InboxData(
        dataPayload[keyPlatform], messagesJsonToList(dataPayload[keyMessages]));
  } catch (e) {
    print(e);
  }
  return null;
}

List<InboxMessage> messagesJsonToList(List<dynamic> messageArray) {
  List<InboxMessage> messages = [];
  for (final message in messageArray) {
    InboxMessage? inboxMessage = messageFromJson(message);
    if (inboxMessage != null) {
      messages.add(inboxMessage);
    }
  }
  return messages;
}

InboxMessage? messageFromJson(Map<String, dynamic> message) {
  try {
    return InboxMessage(
        message.containsKey(keyId) ? message[keyId] : -1,
        message[keyCampaignId],
        textContentFromMap(message[keyTextContent]),
        message[keyIsClicked],
        message.containsKey(keyMediaContent)
            ? mediaFromMap(message[keyMediaContent])
            : null,
        actionsFromMap(message[keyAction]),
        message.containsKey(keyTag) ? message[keyTag] : "general",
        message[keyReceivedTime],
        message[keyExpiryTime],
        message[keyPayload]);
  } catch (e) {
    print(e);
  }
  return null;
}

TextContent textContentFromMap(Map<String, dynamic> textMap) {
  return TextContent(
      textMap.containsKey(keyTextContentTitle)
          ? textMap[keyTextContentTitle]
          : "",
      textMap[keyTextContentMessage],
      textMap.containsKey(keyTextContentSummary)
          ? textMap[keyTextContentSummary]
          : "",
      textMap.containsKey(keyTextContentSubTitle)
          ? textMap[keyTextContentSubTitle]
          : "");
}

Media? mediaFromMap(Map<String, dynamic> mediaMap) {
  if (mediaMap.isEmpty) {
    return null;
  }
  return Media(MediaTypeExt.fromString(mediaMap[keyType]), mediaMap[keyUrl]);
}

List<Action> actionsFromMap(List<dynamic> actions) {
  List<Action> actionList = [];
  for (final action in actions) {
    Action? parsedAction = actionFromMap(action);
    if (parsedAction != null) {
      actionList.add(parsedAction);
    }
  }
  return actionList;
}

Action? actionFromMap(Map<String, dynamic> actionMap) {
  ActionType actionType = ActionTypeExt.fromString(actionMap[keyActionType]);
  switch (actionType) {
    case ActionType.navigation:
      return navigationActionFromMap(actionType, actionMap);
  }
  return null;
}

NavigationAction navigationActionFromMap(
    ActionType actionType, Map<String, dynamic> navigationMap) {
  return NavigationAction(
      actionType,
      NavigationTypeExt.fromString(navigationMap[keyNavigationType]),
      navigationMap[keyValue],
      navigationMap[keyKvPair]);
}

Map<String, String> mapFromTextContent(TextContent content) {
  return <String, String>{
    keyTextContentTitle: content.title,
    keyTextContentMessage: content.message,
    keyTextContentSummary: content.summary,
    keyTextContentSubTitle: content.subtitle
  };
}

Map<String, String> mapFromMedia(Media media) {
  return <String, String>{keyType: media.mediaType.asString, keyUrl: media.url};
}

List<Map<String, dynamic>> actionsListFromModel(List<Action> actions) {
  List<Map<String, dynamic>> actionsList = [];
  for (final action in actions) {
    Map<String, dynamic>? actionMap = actionToMap(action);
    if (actionMap != null) {
      actionsList.add(actionMap);
    }
  }
  return actionsList;
}

Map<String, dynamic>? actionToMap(Action action) {
  switch (action.actionType) {
    case ActionType.navigation:
      return navigationActionToMap(action as NavigationAction);
  }
  return null;
}

Map<String, dynamic> navigationActionToMap(NavigationAction navigationAction) {
  Map<String, dynamic> navigationMap = {
    keyActionType: navigationAction.actionType.asString,
    keyNavigationType: navigationAction.navigationType.asString,
    keyValue: navigationAction.value,
    keyKvPair: navigationAction.kvPair
  };
  return navigationMap;
}
