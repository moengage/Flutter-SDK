import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:moengage_cards_platform_interface/moengage_cards_platform_interface.dart';

class CardsComparator {
  bool isCardEqual(Card card1, Card card2) {
    return card1.id == card2.id &&
        card1.category == card1.category &&
        card1.cardId == card2.cardId &&
        isTemplateEqual(card1.template, card2.template) &&
        isMetaDataEqual(card1.metaData, card2.metaData);
  }

  bool isTemplateEqual(Template template1, Template template2) {
    return mapEquals(template1.kvPairs, template2.kvPairs) &&
        template1.templateType == template2.templateType &&
        isContainersEqual(template1.containers, template2.containers);
  }

  bool isContainersEqual(
    List<Container> containers1,
    List<Container> containers2,
  ) {
    if (containers1.length != containers2.length) return false;
    for (int i = 0; i < containers1.length; i++) {
      if (!isContainerEqual(containers1[i], containers2[i])) {
        return false;
      }
    }
    return true;
  }

  bool isContainerEqual(Container containers1, Container containers2) {
    return containers1.templateType == containers2.templateType &&
        containers1.id == containers2.id &&
        isContainerStyleEqual(containers1.style, containers2.style) &&
        isActionsEqual(containers1.actionList, containers2.actionList) &&
        isWidgetsEqual(containers1.widgets, containers2.widgets);
  }

  bool isContainerStyleEqual(ContainerStyle? style1, ContainerStyle? style2) {
    if (style1 == style2) return true;
    if (style1 == null || style2 == null) return false;
    return style1.backgroundColor == style2.backgroundColor;
  }

  bool isActionsEqual(List<Action> actionList1, List<Action> actionList2) {
    if (actionList1.length != actionList1.length) return false;
    for (int i = 0; i < actionList1.length; i++) {
      if (!isActionEqual(actionList1[i], actionList2[i])) {
        return false;
      }
    }
    return true;
  }

  bool isActionEqual(Action? action1, Action? action2) {
    if (action1 == action2) return true;
    if (action1 == null || action2 == null) return false;
    if (action1 is NavigationAction && action2 is NavigationAction) {
      return isNavigationActionEqual(action1, action2);
    }
    return action1.actionType == action2.actionType;
  }

  bool isNavigationActionEqual(
    NavigationAction? action1,
    NavigationAction? action2,
  ) {
    if (action1 == action2) return true;
    if (action1 == null || action2 == null) return false;
    return action1.value == action2.value &&
        mapEquals(action1.keyValuePairs, action2.keyValuePairs) &&
        action1.navigationType == action2.navigationType &&
        action1.actionType == action2.actionType;
  }

  bool isWidgetsEqual(List<Widget> widgets1, List<Widget> widgets2) {
    if (widgets1.length != widgets1.length) return false;
    for (int i = 0; i < widgets1.length; i++) {
      if (!isWidgetEqual(widgets1[i], widgets2[i])) {
        return false;
      }
    }
    return true;
  }

  bool isWidgetStyleEqual(
    WidgetStyle? widgetStyle1,
    WidgetStyle? widgetStyle2,
  ) {
    if (widgetStyle1 == null && widgetStyle2 == null) return true;
    if (widgetStyle1 == null || widgetStyle2 == null) return false;
    if (widgetStyle1.backgroundColor != widgetStyle2.backgroundColor) {
      return false;
    }
    if (widgetStyle1.runtimeType != widgetStyle2.runtimeType) return false;
    if (widgetStyle1 is ButtonStyle && widgetStyle2 is ButtonStyle) {
      return widgetStyle1.fontSize == widgetStyle2.fontSize;
    }
    if (widgetStyle1 is ImageStyle && widgetStyle2 is ImageStyle) {
      return true;
    }
    if (widgetStyle1 is TextStyle && widgetStyle2 is TextStyle) {
      return widgetStyle1.fontSize == widgetStyle2.fontSize;
    }
    return false;
  }

  bool isWidgetEqual(Widget widget1, Widget widget2) {
    return isWidgetStyleEqual(widget1.style, widget2.style) &&
        widget2.id == widget1.id &&
        widget2.widgetType == widget1.widgetType &&
        widget1.content == widget2.content &&
        isActionsEqual(widget1.actionList, widget2.actionList);
  }

  bool isMetaDataEqual(MetaData metaData1, MetaData metaData2) {
    return metaData1.isNewCard == metaData2.isNewCard &&
        mapEquals(metaData2.campaignPayload, metaData1.campaignPayload) &&
        mapEquals(metaData2.metaData, metaData1.metaData) &&
        metaData1.deletionTime == metaData2.deletionTime &&
        metaData1.updatedTime == metaData2.updatedTime &&
        metaData1.createdAt == metaData2.createdAt &&
        isCampaignStateEqual(
          metaData1.campaignState,
          metaData2.campaignState,
        ) &&
        isDisplayControlEqual(
          metaData1.displayControl,
          metaData2.displayControl,
        );
  }

  bool isCampaignStateEqual(
    CampaignState campaignState1,
    CampaignState campaignState2,
  ) {
    return campaignState1.isClicked == campaignState2.isClicked &&
        campaignState1.firstReceived == campaignState2.firstReceived &&
        campaignState1.firstSeen == campaignState2.firstSeen &&
        campaignState1.totalShowCount == campaignState2.totalShowCount &&
        campaignState1.localShowCount == campaignState2.localShowCount;
  }

  bool isDisplayControlEqual(
    DisplayControl displayControl1,
    DisplayControl displayControl2,
  ) {
    return displayControl1.isPinned == displayControl2.isPinned &&
        displayControl1.expireAfterDelivered ==
            displayControl2.expireAfterDelivered &&
        displayControl1.expireAfterSeen == displayControl2.expireAfterSeen &&
        displayControl1.expireAt == displayControl2.expireAt &&
        displayControl1.maxCount == displayControl2.maxCount &&
        isShowTimeEqual(displayControl1.showTime, displayControl2.showTime);
  }

  bool isShowTimeEqual(ShowTime showTime1, ShowTime showTime2) {
    return showTime1.startTime == showTime2.startTime;
  }

  bool isCardInfoEqual(CardsInfo cardsInfo1, CardsInfo cardsInfo2) {
    return cardsInfo1.shouldShowAllTab == cardsInfo2.shouldShowAllTab &&
        const ListEquality()
            .equals(cardsInfo1.categories, cardsInfo2.categories) &&
        isCardsEqual(cardsInfo1.cards, cardsInfo2.cards);
  }

  bool isSyncDataEquals(
    SyncCompleteData syncCompleteData1,
    SyncCompleteData syncCompleteData2,
  ) {
    return syncCompleteData1.hasUpdates == syncCompleteData2.hasUpdates &&
        syncCompleteData1.syncType == syncCompleteData2.syncType;
  }

  bool isCardsEqual(List<Card> cards1, List<Card> cards2) {
    if (cards1.length != cards2.length) return false;
    for (int i = 0; i < cards1.length; i++) {
      if (!isCardEqual(cards1[i], cards2[i])) {
        return false;
      }
    }
    return true;
  }

  bool isCardDataEquals(CardsData cardsData1, CardsData cardsData2) {
    return cardsData1.category == cardsData2.category &&
        isCardsEqual(cardsData1.cards, cardsData2.cards);
  }
}
