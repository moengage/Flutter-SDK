import 'dart:developer';

import 'package:flutter/services.dart';

class SribuuMoengage {
  MethodChannel _channel = MethodChannel('com.moengage/sribuu');

  void configureMoEngage() {
    log('================================================================================================================== [dart] SribuuMoengage.configureMoEngage()');
    _channel.invokeMethod('configureMoEngage');
  }
}