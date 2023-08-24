import '../../internal/constants.dart';
import 'widget_style.dart';

///Style for Button Widget - [WidgetType.text]
class TextStyle extends WidgetStyle {
  /// [TextStyle] Constructor
  TextStyle({required String backgroundColor, required this.fontSize})
      : super(backgroundColor);

  /// Get [TextStyle] from Json [Map]
  factory TextStyle.fromJson(Map<String, dynamic> json) {
    return TextStyle(
      backgroundColor:
          (json[keyBackgroundColor] ?? defaultTextBgColor) as String,
      fontSize: (json[keyFontSize] ?? defaultFontSize) as int,
    );
  }

  ///Font Size for Text Widget
  int fontSize;

  @override
  Map<String, dynamic> toJson() =>
      {keyBackgroundColor: backgroundColor, keyFontSize: fontSize};
}
