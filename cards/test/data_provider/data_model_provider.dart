import 'package:moengage_cards/moengage_cards.dart';
import 'package:moengage_cards/src/model/container_style.dart';

final cardModel = Card(
    id: 210,
    cardId: "123457",
    category: "promotions",
    template: Template(
        templateType: TemplateType.illustration,
        kvPairs: {},
        containers: [
          Container(
              id: 10,
              templateType: TemplateType.illustration,
              style: ContainerStyle(
                backgroundColor: "#ffffff",
              ),
              actionList: [
                NavigationAction(
                    actionType: ActionType.navigate,
                    navigationType: NavigationType.deepLink,
                    value: "https://google.com",
                    keyValuePairs: {})
              ],
              widgets: [
                Widget(
                    id: 0,
                    widgetType: WidgetType.image,
                    content: "https://picsum.photos/200/200",
                    style: ImageStyle(backgroundColor: "#1a2a3a"),
                    actionList: [
                      NavigationAction(
                          actionType: ActionType.navigate,
                          navigationType: NavigationType.screenName,
                          value: "com.moengage.sampleapp.MainActivity",
                          keyValuePairs: {})
                    ]),
                Widget(
                    id: 1,
                    widgetType: WidgetType.text,
                    content: "Some Header",
                    style: TextStyle(backgroundColor: "#ed2a4a", fontSize: 20),
                    actionList: []),
                Widget(
                    id: 2,
                    widgetType: WidgetType.text,
                    content: "Some message",
                    style: TextStyle(backgroundColor: "#ed2a4a", fontSize: 20),
                    actionList: []),
                Widget(
                    id: 3,
                    widgetType: WidgetType.button,
                    content: "CLICK ME!",
                    style: TextStyle(backgroundColor: "#FFFFF", fontSize: 2),
                    actionList: []),
              ])
        ]),
    metaData: MetaData(
        campaignState: CampaignState(
            localShowCount: 0,
            isClicked: false,
            firstReceived: 14545545,
            firstSeen: 12333566,
            totalShowCount: 10),
        deletionTime: 12333566,
        createdAt: 123456789,
        displayControl: DisplayControl(
            expireAt: 100000,
            expireAfterSeen: 1233456,
            expireAfterDelivered: 2592000,
            maxCount: 10,
            isPinned: false,
            showTime: ShowTime(startTime: "11:11", endTime: "12:22")),
        metaData: {},
        isNewCard: false,
        updatedTime: 54768,
        campaignPayload: {}));

final cardsInfoModel = CardsInfo(
    cards: [cardModel], categories: ["promotions"], isAllCategoryEnabled: true);

final cardsDataModel = CardsData(category: "promotions", cards: [cardModel]);

final syncCompleteDataModel =
    SyncCompleteData(syncType: SyncType.pullToRefresh, hasUpdates: true);
