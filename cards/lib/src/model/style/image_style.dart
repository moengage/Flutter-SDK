import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/style/widget_style.dart';
import 'package:moengage_cards/src/model/enums/widget_type.dart';

///Style for Button Widget - [WidgetType.image]
class ImageStyle extends WidgetStyle {
  ImageStyle({required String backgroundColor}) : super(backgroundColor);

  factory ImageStyle.fromJson(Map<String, dynamic> json) {
    return ImageStyle(
      backgroundColor: json[keyBackgroundColor] ?? defaultTextBgColor,
    );
  }

  @override
  Map<String, dynamic> toJson() => {keyBackgroundColor: backgroundColor};
}
