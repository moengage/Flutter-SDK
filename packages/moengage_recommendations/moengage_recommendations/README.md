# MoEngage Recommendations Plugin

Flutter Plugin for using the Recommendations feature of the MoEngage Platform.

## SDK Installation

To add the MoEngage Recommendations plugin to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_recommendations.svg)

```yaml
dependencies:
 moengage_recommendations: $latestSdkVersion
```
replace `$latestSdkVersion` with the latest SDK version.

Run flutter packages get to install the SDK.

Note: This plugin is dependent on `moengage_flutter` plugin. Make sure you have installed the `moengage_flutter` plugin as well.

Refer to the [Documentation](https://developers.moengage.com/hc/en-us) for complete integration guide.

## Usage

### Initialization

```dart
import 'package:moengage_recommendations/moengage_recommendations.dart';

final MoEngageRecommendations recommendations = MoEngageRecommendations('<YOUR_APP_ID>');
```

### Fetch Recommendations

```dart
try {
  final RecommendedItems result = await recommendations.fetchRecommendations(
    'clothing',
    itemId: 'shirts',
    includedFields: {'size', 'color'},
  );
  // `result.items` may be empty — that means there is nothing to recommend for this user.
  render(result.items);
} on RecommendationsFailure catch (failure) {
  handle(failure.failureReason);
}
```

Item attribute keys and their types are defined by the catalog on the dashboard and are passed
through as-is, so keys are `snake_case` and a price arrives as a number. Read numeric attributes
as `(value as num).toDouble()` — a catalog price of `199.99` decodes to a `double` while `200`
decodes to an `int`.
