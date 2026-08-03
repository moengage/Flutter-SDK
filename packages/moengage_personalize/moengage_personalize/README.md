# MoEngage Personalize Plugin

Personalize Experience Plugin for MoEngage Platform

## SDK Installation

To add the MoEngage Flutter SDK to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_personalize.svg)

```yaml
dependencies:
 moengage_personalize: $latestSdkVersion
```
replace `$latestSdkVersion` with the latest SDK version.

Run flutter packages get to install the SDK.
 
 Note: This plugin is dependent on `moengage_flutter` plugin. Make sure you have installed the `moengage_flutter` plugin as well.

Refer to the [Documentation](https://developers.moengage.com/hc/en-us) for complete integration guide.

## Usage

### Initialization

```dart
import 'package:moengage_personalize/moengage_personalize.dart';

final personalize = MoEngagePersonalize('<YOUR_APP_ID>');
```

### Fetch experience metadata

Retrieve metadata for all experiences matching the given statuses:

```dart
try {
  final meta = await personalize.fetchExperiencesMeta(
    [ExperienceStatus.active, ExperienceStatus.paused],
  );
  for (final exp in meta.experiences) {
    print('${exp.experienceKey}: ${exp.status}');
  }
} on PersonalizeError catch (e) {
  print('Error: ${e.code} — ${e.message}');
}
```

### Fetch experiences

Fetch fully resolved experience campaigns by key:

```dart
try {
  final result = await personalize.fetchExperiences(
    ['welcome_banner', 'home_hero'],
    attributes: {'locale': 'en'},
  );
  for (final exp in result.experiences) {
    print('${exp.experienceKey}: ${exp.payload}');
  }
  for (final failure in result.failures) {
    print('Failed: ${failure.reason} for ${failure.experienceKeys}');
  }
} on PersonalizeError catch (e) {
  print('Error: ${e.code} — ${e.message}');
}
```

### Fetch a single experience

Convenience wrapper for a single key:

```dart
final result = await personalize.fetchExperience('welcome_banner');
```

### Track experiences shown

Call when one or more experience campaigns are rendered:

```dart
personalize.experiencesShown([experienceCampaign]);
```

### Track experience clicked

Call when the user interacts with an experience:

```dart
personalize.experienceClicked(experienceCampaign);
```

### Track offerings shown

Call when one or more offerings inside an experience are rendered:

```dart
personalize.offeringsShown([
  {'offer_id': 'promo_123', 'position': '1'},
]);
```

### Track offering clicked

Call when the user clicks a specific offering:

```dart
personalize.offeringClicked(
  experienceCampaign,
  {'offer_id': 'promo_123'},
);
```
