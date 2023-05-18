import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/model/widget_style.dart';

class TextStyle extends WidgetStyle {

  int fontSize;

  TextStyle({required String backgroundColor, required this.fontSize}) : super(backgroundColor);

  factory TextStyle.fromJson(Map<String, dynamic> json){
    return TextStyle(
        backgroundColor: json[keyBackgroundColor] ?? defaultTextBgColor,
        fontSize: json[keyFontSize] ?? defaultFontSize
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {keyBackgroundColor: backgroundColor,keyFontSize: fontSize};

}
