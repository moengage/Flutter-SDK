# MoEngage Cards Plugin

Cards Plugin for MoEngage Platform

## SDK Installation

To add the MoEngage Cards SDK to your application, edit your application's `pubspec.yaml` file
and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_cards.svg)

```yaml
dependencies:
  moengage_cards: $latestSdkVersion
```

replace `$latestSdkVersion` with the latest SDK version.

### Android Installation

![MavenBadge](https://maven-badges.herokuapp.com/maven-central/com.moengage/cards-core/badge.svg)

Once you install the Flutter Plugin add MoEngage's native Android SDK dependency to the Android
project of your application.
Navigate to `android --> app --> build.gradle`. Add the MoEngage Android SDK's dependency in
the `dependencies` block

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation("com.moengage:cards-core:$sdkVersion")
}
```

Run flutter packages get to install the SDK.

## Usage

Cards Initialization

```
import 'package:moengage_cards/moengage_cards.dart' as moe;
moe.MoEngageCards cards = moe.MoEngageCards("<MOE_APP_ID>");
cards.initialize();
```

Set Cards Sync complete callback listener

```
cards.setSyncCompleteListener((data) {
      debugPrint("Cards Sync Listener: $data");
});
```

Call this API when user lands on Inbox Screen , with SyncComplete Callback

```
cards.onCardsSectionLoaded((data) {
    debugPrint("Cards Inbox Open Sync Listener: $data");
});
```

Call this API when user dismisses Inbox Screen

```
cards.onCardsSectionUnLoaded();
```

Notify SDK that , card is delivered. Used for Analytics Purposes

```
cards.cardDelivered();
```

Fetch All Related Data

```
cards.getCardsInfo().then((cardsData) {
  //Update UI
});
```

Ask the SDK to refresh cards on user request. Used to mimic Pull to Refresh Behaviour

```
cards.refreshCards((data) {
   if (data?.hasUpdates == true) {
     // Refetch Cards
     cards.getCardsInfo().then((cardsData) {
        //Update UI
     });
   }
});
```

Notify SDK that card is clicked. Used for Analytics Purposes

```
cards.cardClicked(card, widgetId);
```

Notify SDK that card is Shown to the User. Used for Analytics Purposes

```
cards.cardShown(card);
```

Fetch Cards For Given Category

```
final category = "Promotions";
final cardsData = await cards.getCardsForCategory(category);
```

Get UnClicked Cards Count

```
final unClickedCardsCount = await cards.getUnClickedCardsCount();
```

Get New Cards Count

```
final newCardsCount = await cards.getNewCardsCount();
```

Returns a list of categories to be shown

```
final cardsCategories = await cards.getCardsCategories();
```

Return true if All cards category should be shown

```
final isAllCategoryEnabled = await cards.isAllCategoryEnabled();
```

Delete Given card.

```
cards.deleteCard(card);
```

Delete Multiple Cards

```
final cards = [];
cards.deleteCards(cards);
```

Fetch Cards Data

```
cards.fetchCards().then((cardsData) {
  //Update UI
});
```

Note: This plugin is dependent on `moengage_flutter` plugin. Make sure you have installed
the `moengage_flutter` plugin as well.
