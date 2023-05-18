
import 'package:moengage_cards/src/internal/contants.dart';

class ContainerStyle{
  String backgroundColor;

  ContainerStyle({required this.backgroundColor});

  factory ContainerStyle.fromJson(Map<String,dynamic> json){
    return ContainerStyle(
      backgroundColor: json[keyBackgroundColor]
    );
  }

  Map<String,dynamic> toJson() => {
    keyBackgroundColor : backgroundColor
  };
}