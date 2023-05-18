
import 'package:moengage_cards/src/internal/contants.dart';

class ShowTime{
  String startTime;
  String endTime;

  ShowTime({required this.startTime, required this.endTime});

  factory ShowTime.fromJson(Map<String,dynamic> json){
    return ShowTime(
      startTime: json[keyStartTime]??"",
      endTime: json[keyEndTime]??""
    );
  }

  Map<String,dynamic> toJson() => {
    keyStartTime: startTime,
    keyEndTime: endTime
  };

}