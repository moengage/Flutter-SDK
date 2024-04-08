import '../../internal/constants.dart';
import 'widget_style.dart';

///Style for Button Widget - [WidgetType.image]
class ImageStyle extends WidgetStyle {
  /// [ImageStyle] Constructor
  ImageStyle({required String backgroundColor}) : super(backgroundColor);

  /// Get [ImageStyle] from Json [Map]
  factory ImageStyle.fromJson(Map<String, dynamic> json) {
    return ImageStyle(
      backgroundColor:
          (json[keyBackgroundColor] ?? defaultTextBgColor) as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {keyBackgroundColor: backgroundColor};
}
