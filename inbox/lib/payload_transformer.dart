import 'dart:convert';

import 'package:moengage_inbox/action.dart';
import 'package:moengage_inbox/action_type.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/inbox_message.dart';
import 'package:moengage_inbox/media.dart';
import 'package:moengage_inbox/media_type.dart';
import 'package:moengage_inbox/navigation_action.dart';
import 'package:moengage_inbox/navigation_type.dart';
import 'package:moengage_inbox/text_content.dart';

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
  if (inboxMessage.media != null) {
    message[MEDIA_CONTENT] = mapFromMedia(inboxMessage.media);
  }
  return message;
}

InboxData deSerializeInboxMessages(dynamic messagesPayload) {
  Map<String, dynamic> message = json.decode(messagesPayload);
  return InboxData(message[PLATFORM], messagesJsonToList(message[MESSAGES]));
}

List<InboxMessage> messagesJsonToList(List<dynamic> messageArray) {
  List<InboxMessage> messages = List<InboxMessage>();
  for (final message in messageArray) {
    InboxMessage inboxMessage = messageFromJson(message);
    if (inboxMessage != null) {
      messages.add(inboxMessage);
    }
  }
  return messages;
}

InboxMessage messageFromJson(Map<String, dynamic> message) {
  try {
    return InboxMessage(
        message.containsKey(ID) ? message[ID] : -1,
        message[CAMPAIGN_ID],
        textContentFromMap(message[TEXT_CONTENT]),
        message[IS_CLICKED],
        message.containsKey(MEDIA_CONTENT)
            ? mediaFromMap(message[MEDIA_CONTENT])
            : null,
        mediaFromMap(message[MEDIA_CONTENT]),
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

Media mediaFromMap(Map<String, dynamic> mediaMap) {
  if (mediaMap.isEmpty) {
    return null;
  }
  return Media(MediaTypeExt.fromString(mediaMap[TYPE]), mediaMap[URL]);
}

List<Action> actionsFromMap(List<dynamic> actions) {
  List<Action> actionList = List<Action>();
  for (final action in actions) {
    Action parsedAction = actionFromMap(action);
    if (parsedAction != null) {
      actionList.add(parsedAction);
    }
  }
  return actionList;
}

Action actionFromMap(Map<String, dynamic> actionMap) {
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
  List<Map<String, dynamic>> actionsList = List<Map<String, dynamic>>();
  for (final action in actions) {
    Map<String, dynamic> actionMap = actionToMap(action);
    if (actionMap != null) {
      actionsList.add(actionMap);
    }
  }
  return actionsList;
}

Map<String, dynamic> actionToMap(Action action) {
  switch (action.actionType) {
    case ActionType.navigation:
      return navigationActionToMap(action);
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

const String PLATFORM = "platform";
const String MESSAGES = "messages";

const String ID = "id";
const String CAMPAIGN_ID = "campaignId";
const String IS_CLICKED = "isClicked";
const String RECEIVED_TIME = "receivedTime";
const String EXPIRY_TIME = "expiry";
const String PAYLOAD = "payload";
const String TAG = "tag";

const String TEXT_CONTENT = "text";
const String TEXT_CONTENT_TITLE = "title";
const String TEXT_CONTENT_MESSAGE = "message";
const String TEXT_CONTENT_SUMMARY = "summary";
const String TEXT_CONTENT_SUB_TITLE = "subtitle";

const String MEDIA_CONTENT = "media";

const String TYPE = "type";
const String URL = "url";

const String ACTION = "action";
const String ACTION_TYPE = "actionType";
const String NAVIGATION_TYPE = "navigationType";
const String VALUE = "value";
const String KV_PAIR = "kvPair";
