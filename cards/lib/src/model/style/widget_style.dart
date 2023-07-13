/// Base style for all widgets.
abstract class WidgetStyle {
  /// Background color for the widget.
  String backgroundColor;

  WidgetStyle(this.backgroundColor);

  Map<String, dynamic> toJson();
}
