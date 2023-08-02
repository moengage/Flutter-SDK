import '../../internal/constants.dart';

/// Style for [Container] widget
class ContainerStyle {
  ContainerStyle({required this.backgroundColor});

  factory ContainerStyle.fromJson(Map<String, dynamic> json) {
    return ContainerStyle(
      backgroundColor:
          (json[keyBackgroundColor] ?? defaultContainerBgColor) as String,
    );
  }

  /// Container Background Color Hex Code
  String backgroundColor;

  Map<String, dynamic> toJson() => {keyBackgroundColor: backgroundColor};
}
