import '../../internal/constants.dart';
import 'widget_style.dart';

///Style for Button Widget - [WidgetType.button]
class ButtonStyle extends WidgetStyle {
  /// [ButtonStyle] Constructor
  ButtonStyle({required String backgroundColor, required this.fontSize})
      : super(backgroundColor);

  /// Get [ButtonStyle] from Json [Map]
  factory ButtonStyle.fromJson(Map<String, dynamic> json) {
    return ButtonStyle(
      backgroundColor:
          (json[keyBackgroundColor] ?? defaultTextBgColor) as String,
      fontSize: (json[keyFontSize] ?? defaultFontSize) as int,
    );
  }

  /// Font Size for Button Text
  int fontSize;

  @override
  Map<String, dynamic> toJson() =>
      {keyBackgroundColor: backgroundColor, keyFontSize: fontSize};
}
