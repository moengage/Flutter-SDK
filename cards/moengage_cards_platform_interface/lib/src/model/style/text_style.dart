import '../../internal/constants.dart';
import 'widget_style.dart';

///Style for Button Widget - [WidgetType.text]
class TextStyle extends WidgetStyle {
  TextStyle({required String backgroundColor, required this.fontSize})
      : super(backgroundColor);

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
