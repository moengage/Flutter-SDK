import '../../internal/constants.dart';

/// Style for [Container] widget
class ContainerStyle {
  /// [ContainerStyle] Constructor
  ContainerStyle({required this.backgroundColor});

  /// Get [ContainerStyle] from Json [Map]
  factory ContainerStyle.fromJson(Map<String, dynamic> json) {
    return ContainerStyle(
      backgroundColor:
          (json[keyBackgroundColor] ?? defaultContainerBgColor) as String,
    );
  }

  /// Container Background Color Hex Code
  String backgroundColor;

  /// Convert [ContainerStyle] to Json [Map]
  Map<String, dynamic> toJson() => {keyBackgroundColor: backgroundColor};
}
