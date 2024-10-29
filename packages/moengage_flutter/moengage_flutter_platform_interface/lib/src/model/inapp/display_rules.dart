import '../../../moengage_flutter_platform_interface.dart';

/// InApp Campaign Display Rules
class Rules {
  /// Creates an instance of [Rules] with the provided [screenName] and [context]
  Rules({this.screenName, List<String>? context}) : context = context ?? [];

  /// Get [Rules] from Json [Map]
  factory Rules.fromJson(Map<String, dynamic> json) => Rules(
        screenName: (json[keyScreenName] ?? '').toString(),
        context: List.from((json[keyContexts] ?? []) as Iterable)
            .map((e) => e.toString())
            .toList(),
      );

  /// Screen name on which the campaign should be shown.
  String? screenName;

  /// Context for which the campaign should be shown.
  List<String> context;

  @override
  String toString() {
    return 'Rules{screenName: $screenName, context: $context}';
  }
}
