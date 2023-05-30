import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/style/widget_style.dart';
import 'package:moengage_cards/src/model/enums/widget_type.dart';

///Style for Button Widget - [WidgetType.text]
class TextStyle extends WidgetStyle {
  ///Font Size for Text Widget
  int fontSize;

  TextStyle({required String backgroundColor, required this.fontSize})
      : super(backgroundColor);

  factory TextStyle.fromJson(Map<String, dynamic> json) {
    return TextStyle(
        backgroundColor: json[keyBackgroundColor] ?? defaultTextBgColor,
        fontSize: json[keyFontSize] ?? defaultFontSize);
  }

  @override
  Map<String, dynamic> toJson() =>
      {keyBackgroundColor: backgroundColor, keyFontSize: fontSize};
}
