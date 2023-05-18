
import 'package:moengage_cards/src/model/widget_style.dart';

import '../internal/contants.dart';

class ButtonStyle extends WidgetStyle {
  int fontSize;

  ButtonStyle({required String backgroundColor, required this.fontSize})
      : super(backgroundColor);

  factory ButtonStyle.fromJson(Map<String, dynamic> json) {
    return ButtonStyle(
        backgroundColor: json[keyBackgroundColor] ?? defaultTextBgColor,
        fontSize: json[keyFontSize] ?? defaultFontSize);
  }

  @override
  Map<String, dynamic> toJson() =>
      {keyBackgroundColor: backgroundColor, keyFontSize: fontSize};
}