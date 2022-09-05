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
  Map<String, dynamic> dataPayload = payload[DATA];
  if (dataPayload.isNotEmpty) {
    int unclickedCount = dataPayload.containsKey(UNCLICKED_COUNT)
        ? dataPayload[UNCLICKED_COUNT]
        : 0;
    return unclickedCount;
  }

  return 0;
}

Map<String, dynamic> messageToMap(InboxMessage inboxMessage) {
  Map<String, dynamic> message = {
    ID: inboxMessage.id,
    CAMPAIGN_ID: inboxMessage.campaignId,
    IS_CLICKED: inboxMessage.isClicked,
    RECEIVED_TIME: inboxMessage.receivedTime,
    EXPIRY_TIME: inboxMessage.expiry,
    PAYLOAD: inboxMessage.payload,
    TEXT_CONTENT: mapFromTextContent(inboxMessage.textContent),
    ACTION: actionsListFromModel(inboxMessage.action)
  };
  Media? media = inboxMessage.media;
  if (media != null) {
    message[MEDIA_CONTENT] = mapFromMedia(media);
  }
  return message;
}

InboxData? deSerializeInboxMessages(dynamic messagesPayload) {
  try {
    Map<String, dynamic> message = json.decode(messagesPayload);
    Map<String, dynamic> dataPayload = message[DATA];
    return InboxData(
        dataPayload[PLATFORM], messagesJsonToList(dataPayload[MESSAGES]));
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
        message.containsKey(ID) ? message[ID] : -1,
        message[CAMPAIGN_ID],
        textContentFromMap(message[TEXT_CONTENT]),
        message[IS_CLICKED],
        message.containsKey(MEDIA_CONTENT)
            ? mediaFromMap(message[MEDIA_CONTENT])
            : null,
        actionsFromMap(message[ACTION]),
        message.containsKey(TAG) ? message[TAG] : "general",
        message[RECEIVED_TIME],
        message[EXPIRY_TIME],
        message[PAYLOAD]);
  } catch (e) {
    print(e);
  }
  return null;
}

TextContent textContentFromMap(Map<String, dynamic> textMap) {
  return TextContent(
      textMap.containsKey(TEXT_CONTENT_TITLE)
          ? textMap[TEXT_CONTENT_TITLE]
          : "",
      textMap[TEXT_CONTENT_MESSAGE],
      textMap.containsKey(TEXT_CONTENT_SUMMARY)
          ? textMap[TEXT_CONTENT_SUMMARY]
          : "",
      textMap.containsKey(TEXT_CONTENT_SUB_TITLE)
          ? textMap[TEXT_CONTENT_SUB_TITLE]
          : "");
}

Media? mediaFromMap(Map<String, dynamic> mediaMap) {
  if (mediaMap.isEmpty) {
    return null;
  }
  return Media(MediaTypeExt.fromString(mediaMap[TYPE]), mediaMap[URL]);
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
  ActionType actionType = ActionTypeExt.fromString(actionMap[ACTION_TYPE]);
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
      NavigationTypeExt.fromString(navigationMap[NAVIGATION_TYPE]),
      navigationMap[VALUE],
      navigationMap[KV_PAIR]);
}

Map<String, String> mapFromTextContent(TextContent content) {
  return <String, String>{
    TEXT_CONTENT_TITLE: content.title,
    TEXT_CONTENT_MESSAGE: content.message,
    TEXT_CONTENT_SUMMARY: content.summary,
    TEXT_CONTENT_SUB_TITLE: content.subtitle
  };
}

Map<String, String> mapFromMedia(Media media) {
  return <String, String>{TYPE: media.mediaType.asString, URL: media.url};
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
    ACTION_TYPE: navigationAction.actionType.asString,
    NAVIGATION_TYPE: navigationAction.navigationType.asString,
    VALUE: navigationAction.value,
    KV_PAIR: navigationAction.kvPair
  };
  return navigationMap;
}
