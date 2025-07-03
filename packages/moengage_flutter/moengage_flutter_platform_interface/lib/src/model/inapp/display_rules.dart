import '../../../moengage_flutter_platform_interface.dart';

/// InApp Campaign Display Rules
class Rules {
  /// Creates an instance of [Rules] with the provided [screenName] and [context]
  Rules({
      @Deprecated('This parameter is deprecated and will be removed in future releases. Use [screenNames] instead')
      this.screenName,
      List<String>? context,
      List<String>? screenNames})
      : context = context ?? [],
        screenNames = screenNames ?? [];

  /// Get [Rules] from Json [Map]
  factory Rules.fromJson(Map<String, dynamic> json) => Rules(
        screenName: (json[keyScreenName] ?? '').toString(),
        context: List.from((json[keyContexts] ?? []) as Iterable)
            .map((e) => e.toString())
            .toList(),
        screenNames: List.from((json[keyScreenNames] ?? []) as Iterable)
            .map((e) => e.toString())
            .toList()
      );

  /// Screen name on which the campaign should be shown.
  @Deprecated('This field is deprecated and will be removed in future releases. Use [screenNames] instead')
  String? screenName;

  /// Context for which the campaign should be shown.
  List<String> context;

  /// Screen Names on which the campaign can be shown.
  List<String> screenNames;

  @override
  String toString() {
    return 'Rules{screenName: $screenName, screenNames: $screenNames, context: $context}';
  }
}
