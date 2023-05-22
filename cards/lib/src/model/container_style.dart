import 'package:moengage_cards/moengage_cards.dart';
import 'package:moengage_cards/src/internal/contants.dart';

/// Style for [Container] widget
class ContainerStyle {
  /// Container Background Color Hex Code
  String backgroundColor;

  ContainerStyle({required this.backgroundColor});

  factory ContainerStyle.fromJson(Map<String, dynamic> json) {
    return ContainerStyle(backgroundColor: json[keyBackgroundColor]);
  }

  Map<String, dynamic> toJson() => {keyBackgroundColor: backgroundColor};
}
