
import 'package:flutter/services.dart';

const String sribuuChannelName = "com.moengage/sribuu";
const String methodConfigureMoEngage = 'configureMoEngage';

class SribuuMoEngageBridge {
  MethodChannel _sribuuMethodChannel = MethodChannel(sribuuChannelName);

  void configureMoEngage({required String appId}) {
    var arguments = {
      'appId': appId,
    };

    _sribuuMethodChannel.invokeMethod(methodConfigureMoEngage, arguments);
  }
}

class SribuuMoEngage {
  
}

