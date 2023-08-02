import 'dart:convert';

import 'package:moengage_flutter_platform_interface/src/internal/logger.dart';
import 'internal/constants.dart';
import 'model/models.dart';

const String _tag = '${TAG}PayloadTransformer';

// Unclicked Count
int fetchUnclickedCount(dynamic unClickedPayload) {
  final payload = json.decode(unClickedPayload.toString());
  final dataPayload = payload[keyData];
  if (dataPayload.isNotEmpty == true) {
    final int unclickedCount =
        (dataPayload.containsKey(keyUnClickedCount) == true
            ? dataPayload[keyUnClickedCount]
            : 0) as int;
    return unclickedCount;
  }

  return 0;
}

Map<String, dynamic> messageToMap(InboxMessage inboxMessage) {
  final Map<String, dynamic> message = <String, dynamic>{
    keyId: inboxMessage.id,
    keyCampaignId: inboxMessage.campaignId,
    keyIsClicked: inboxMessage.isClicked,
    keyReceivedTime: inboxMessage.receivedTime,
    keyExpiryTime: inboxMessage.expiry,
    keyPayload: inboxMessage.payload,
    keyTextContent: mapFromTextContent(inboxMessage.textContent),
    keyAction: actionsListFromModel(inboxMessage.action)
  };
  final Media? media = inboxMessage.media;
  if (media != null) {
    message[keyMediaContent] = mapFromMedia(media);
  }
  return message;
}

InboxData? deSerializeInboxMessages(dynamic messagesPayload) {
  try {
    final message = json.decode(messagesPayload.toString());
    final dataPayload = message[keyData];
    return InboxData(dataPayload[keyPlatform].toString(),
        messagesJsonToList(dataPayload[keyMessages] as List));
  } catch (e, stackTrace) {
    Logger.e('$_tag Error: ', error: e, stackTrace: stackTrace);
  }
  return null;
}

List<InboxMessage> messagesJsonToList(List<dynamic> messageArray) {
  final List<InboxMessage> messages = <InboxMessage>[];
  for (final message in messageArray) {
    final InboxMessage? inboxMessage =
        messageFromJson(message as Map<String, dynamic>);
    if (inboxMessage != null) {
      messages.add(inboxMessage);
    }
  }
  return messages;
}

InboxMessage? messageFromJson(Map<String, dynamic> message) {
  try {
    return InboxMessage(
        (message.containsKey(keyId) ? message[keyId] : -1) as int,
        message[keyCampaignId].toString(),
        textContentFromMap(message[keyTextContent] as Map<String, dynamic>),
        (message[keyIsClicked] ?? false) as bool,
        message.containsKey(keyMediaContent)
            ? mediaFromMap(message[keyMediaContent] as Map<String, dynamic>)
            : null,
        actionsFromMap(message[keyAction] as List),
        (message.containsKey(keyTag) ? message[keyTag] : 'general').toString(),
        message[keyReceivedTime].toString(),
        message[keyExpiryTime].toString(),
        message[keyPayload] as Map<String, dynamic>);
  } catch (e, stacktrace) {
    Logger.e('$_tag Error: messageFromJson InboxMessage ',
        stackTrace: stacktrace);
  }
  return null;
}

TextContent textContentFromMap(Map<String, dynamic> textMap) {
  return TextContent(
      (textMap.containsKey(keyTextContentTitle)
              ? textMap[keyTextContentTitle]
              : '')
          .toString(),
      textMap[keyTextContentMessage].toString(),
      (textMap.containsKey(keyTextContentSummary)
              ? textMap[keyTextContentSummary]
              : '')
          .toString(),
      (textMap.containsKey(keyTextContentSubTitle)
              ? textMap[keyTextContentSubTitle]
              : '')
          .toString());
}

Media? mediaFromMap(Map<String, dynamic> mediaMap) {
  if (mediaMap.isEmpty) {
    return null;
  }
  return Media(MediaTypeExt.fromString(mediaMap[keyType].toString()),
      mediaMap[keyUrl].toString());
}

List<Action> actionsFromMap(List<dynamic> actions) {
  final List<Action> actionList = <Action>[];
  for (final action in actions) {
    final Action? parsedAction = actionFromMap(action as Map<String, dynamic>);
    if (parsedAction != null) {
      actionList.add(parsedAction);
    }
  }
  return actionList;
}

Action? actionFromMap(Map<String, dynamic> actionMap) {
  final ActionType actionType =
      ActionTypeExt.fromString(actionMap[keyActionType].toString());
  switch (actionType) {
    case ActionType.navigation:
      return navigationActionFromMap(actionType, actionMap);
    default:
      return null;
  }
}

NavigationAction navigationActionFromMap(
    ActionType actionType, Map<String, dynamic> navigationMap) {
  return NavigationAction(
      actionType,
      NavigationTypeExt.fromString(navigationMap[keyNavigationType].toString()),
      navigationMap[keyValue].toString(),
      navigationMap[keyKvPair] as Map<String, dynamic>);
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
  final List<Map<String, dynamic>> actionsList = <Map<String, dynamic>>[];
  for (final Action action in actions) {
    final Map<String, dynamic>? actionMap = actionToMap(action);
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
    default:
      return null;
  }
}

Map<String, dynamic> navigationActionToMap(NavigationAction navigationAction) {
  final Map<String, dynamic> navigationMap = <String, dynamic>{
    keyActionType: navigationAction.actionType.asString,
    keyNavigationType: navigationAction.navigationType.asString,
    keyValue: navigationAction.value,
    keyKvPair: navigationAction.kvPair
  };
  return navigationMap;
}
