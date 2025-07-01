/// StaticImageType enum for representing types of static images.
enum StaticImageType {
  /// Image for No cards/Empty State
  emptyState('no_cards'),

  /// Pin Card image
  pinCard('pinned_card'),

  /// Place Holder image for card loading
  loadingPlaceHolder('place_holder');

  const StaticImageType(this.value);

  /// The string value associated with this image type.
  final String value;

  /// Converts a string to the corresponding StaticImageType enum.
  /// Throws an ArgumentError if the string does not match any enum value.
  static StaticImageType fromString(String str) =>
      StaticImageType.values.firstWhere(
        (type) => type.value == str,
        orElse: () => throw ArgumentError('No matching StaticImageType for $str'),
      );
}

/// Extension on StaticImageType for converting an enum instance to its associated string.
extension StaticImageTypeExtension on StaticImageType {
  /// Returns the string value associated with this image type.
  String toShortString() => value;
}
