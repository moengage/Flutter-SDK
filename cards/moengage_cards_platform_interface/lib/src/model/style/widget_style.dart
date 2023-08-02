/// Base style for all widgets.
abstract class WidgetStyle {
  WidgetStyle(this.backgroundColor);

  /// Background color for the widget.
  String backgroundColor;

  Map<String, dynamic> toJson();
}
