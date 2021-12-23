import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/sribuu/android_builder.dart';
import 'package:moengage_flutter/sribuu/ios_builder.dart';

const String sribuuChannelName = "com.moengage/sribuu";
const String methodConfigureMoEngage = 'configureMoEngage';

class SribuuMoEngage {
  final String appId;

  late final Map<String, Map<String, dynamic>?> setupCalls;

  final AndroidOptionBuilder androidOption;

  final IosOptionBuilder iosOption;

  SribuuMoEngage({
    required this.appId,
    required this.androidOption,
    required this.iosOption,
  });

  SribuuMoEngage build() {
    if(Platform.isAndroid) {
      setupCalls = androidOption.setupCalls;
    } else if(Platform.isIOS) {
      setupCalls = iosOption.setupCalls;
    } else {
      setupCalls = {};
    }

    return this;
  }

  static void initialise(SribuuMoEngage sribuuMoEngage) {
    MethodChannel sribuuMethodChannel = MethodChannel(sribuuChannelName);

    var arguments = {
      'appId': sribuuMoEngage.appId,
      'setupCalls': sribuuMoEngage.setupCalls,
    };

    sribuuMethodChannel.invokeMethod(methodConfigureMoEngage, arguments);
  }
}
