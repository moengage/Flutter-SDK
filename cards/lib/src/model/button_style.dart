import 'package:moengage_cards/moengage_cards.dart';

import '../internal/constants.dart';

///Style for Button Widget - [WidgetType.button]
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
