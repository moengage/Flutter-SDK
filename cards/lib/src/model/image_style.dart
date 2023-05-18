
import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/model/widget_style.dart';

class ImageStyle extends WidgetStyle{

  ImageStyle({required String backgroundColor}) : super(backgroundColor);

  factory ImageStyle.fromJson(Map<String, dynamic> json){
    return ImageStyle(
        backgroundColor: json[keyBackgroundColor] ?? defaultTextBgColor,
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {keyBackgroundColor: backgroundColor};

}