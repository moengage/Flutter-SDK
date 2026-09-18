# moengage_recommendations

Flutter Plugin for using the Recommendations feature of the MoEngage Platform.

## Usage

```dart
final MoEngageRecommendations _recommendations = MoEngageRecommendations(WORKSPACE_ID);

try {
  final RecommendedItems result = await _recommendations.fetchRecommendations(
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
