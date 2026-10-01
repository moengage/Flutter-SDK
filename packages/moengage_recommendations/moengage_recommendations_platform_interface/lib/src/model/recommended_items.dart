import '../internal/constants.dart';

/// Recommended items returned for a recommendation campaign.
class RecommendedItems {
  /// [RecommendedItems] Constructor
  RecommendedItems({required this.items});

  /// Creates a [RecommendedItems] from the `data` block of the native payload.
  factory RecommendedItems.fromJson(Map<String, dynamic> data) {
    final itemsList = data[keyItems] as List? ?? [];
    return RecommendedItems(
      items: itemsList
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
    );
  }

  /// Recommended items, may be empty when there is nothing to recommend.
  ///
  /// Attribute keys and value types are defined by the dashboard catalog and are passed through
  /// as-is, so keys are `snake_case` and a price arrives as a number. A catalog price of `199.99`
  /// decodes to a `double` while `200` decodes to an `int` — read numeric attributes as
  /// `(value as num).toDouble()` rather than casting straight to `double`.
  final List<Map<String, dynamic>> items;

  @override
  String toString() {
    return 'RecommendedItems{items: $items}';
  }
}
