import 'dart:convert';

const String testAppId = 'TEST_APP_ID';

const String testRecommendationId = 'clothing';
const String testItemId = 'shirts';

/// Mirrors `json/nativeToHybrid/recommendations/fetchRecommendations.json` in
/// `mobile-sdk-contracts` — attribute keys are `snake_case` and a price is a number, both defined
/// by the dashboard catalog and passed through as-is.
final String fetchRecommendationsSuccessJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'data': {
    'items': [
      {
        'product_id': 'product_001',
        'title': 'Premium Wireless Headphones',
        'price': 199.99,
        'image_link': 'https://example.com/images/headphones.jpg',
        'link': 'https://example.com/products/product_001',
      },
      {
        'product_id': 'product_002',
        'title': 'Wired Earphones',
        'price': 200,
        'in_stock': true,
      },
    ],
  },
});

/// An empty result is a success — it means there is nothing to recommend for this user.
final String fetchRecommendationsEmptyJson = json.encode({
  'accountMeta': {'appId': testAppId},
  'data': {'items': <dynamic>[]},
});

/// A response whose `data` block is missing entirely.
final String fetchRecommendationsMalformedJson = json.encode({
  'accountMeta': {'appId': testAppId},
});
