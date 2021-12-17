import 'package:flutter/services.dart';

class SribuuMoengage {
  MethodChannel _channel = MethodChannel('com.moengage/sribuu');

  void configureMoEngage() {
    _channel.invokeMethod('configureMoEngage');
  }
}