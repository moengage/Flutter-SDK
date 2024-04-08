/// Base style for all widgets.
abstract class WidgetStyle {
  /// [WidgetStyle] Constructor
  WidgetStyle(this.backgroundColor);

  /// Background color for the widget.
  String backgroundColor;

  /// Convert [WidgetStyle] to Json [Map]
  Map<String, dynamic> toJson();
}
