const String moduleTag = "MoEngageCards_";

const String cardsMethodChannel = "com.moengage/cards";

const String methodNameSyncCards = "sync_cards";

const String keyAppId = "appId";
const String keyUnClickedCount = "unClickedCount";
const String keyAccountMeta = "accountMeta";
const String keyData = "data";

const String keySyncCompleteData = "syncCompleteData";
const String keyHasUpdates = "hasUpdates";
const String keySyncType = "syncType";

const String keyId = "id";
const String keyCardId = "card_id";
const String keyCategory = "category";
const String keyTemplateData = "template_data";
const String keyMetaData = "meta_data";
const String keyMetaData1 = "metaData";
const String keyTemplateType = "type";
const String keyKVPairs = "kvPairs";
const String keyContainers = "containers";
const String keyContainerId = "id";
const String keyContainerType = "type";
const String keyContainerStyle = "style";
const String keyBackgroundColor = "bgColor";
const String keyActions = "actions";
const String keyWidgets = "widgets";
const String keyWidgetId = "id";
const String keyWidgetType = "type";
const String keyWidgetContent = "content";
const String keyWidgetStyle = "style";
const String keyFontSize = "fontSize";

const String keyActionType = "name";
const String keyActionValue = "value";
const String keyNavigationType = "type";

const int defaultFontSize = -1;
const String defaultTextBgColor = "#00FFFFFF";

//CampaignState
const String keyLocalShowCount = "localShowCount";
const String keyTotalShowCount = "totalShowCount";
const String keyIsClicked = "isClicked";
const String keyFirstSeen = "firstSeen";
const String keyFirstReceived = "firstReceived";
const String keyIsNewCard = "isNewCard";
const String keyCampaignPayload = "campaignPayload";
const String keyCampaignState = "campaignState";
const String keyDeletionTime = "deletionTime";


const String keyExpireAt = "expire_at";
const String keyExpireAfterSeen = "expire_after_seen";
const String keyExpireAfterDelivered = "expire_after_delivered";
const String keyMaxCount = "max_times_to_show";
const String keyShowTime = "show_time";
const String keyIsPinned = "is_pin";
const String keyStartTime = "start_time";
const String keyEndTime = "end_time";

const String keyDisplayControl = "display_controls";
const String keyShouldShowAllTab = "shouldShowAllTab";
const String keyCategories = "categories";
const String keyCards = "cards";
const String keyCard = "card";
const String keyWidgetIdentifier = "widgetId";
const String keyIsAllCategoryEnabled = "isAllCategoryEnabled";
const String keyNewCardsCount = "newCardsCount";
const String keyUnClickedCardsCount = "unClickedCardsCount";

const String keyUpdatedAt = "updated_at";
const String keyCreatedAt = "created_at";
const String methodInitialize = "initialize";
const String methodRefreshCards = "refreshCards";
const String methodOnCardSectionLoaded = "onCardSectionLoaded";
const String methodOnCardSectionUnLoaded = "onCardSectionUnLoaded";
const String methodAppOpenSyncListener = "appOpenSyncListener";
const String methodCardsCategories = "getCardsCategories";
const String methodCardsInfo = "getCardsInfo";
const String methodCardClicked = "cardClicked";
const String methodCardDelivered = "cardDelivered";
const String methodCardShown = "cardShown";
const String methodCardsForCategory = "cardsForCategory";
const String methodDeleteCards = "deleteCards";
const String methodIsAllCategoryEnabled = "isAllCategoryEnabled";
const String methodNewCardsCount = "getNewCardsCount";
const String methodUnClickedCardsCount = "unClickedCardsCount";

const String methodOnInboxOpenCardsSync = "onInboxOpenCardsSync";
const String methodPullToRefreshCardsSync = "onPullToRefreshCardsSync";
const String methodOnAppOpenCardsSync = "onAppOpenCardsSync";

const String argumentPullToRefreshSync = "PULL_TO_REFRESH";
const String argumentInboxOpenSync = "INBOX_OPEN";
const String argumentAppOpenSync = "APP_OPEN";