import 'package:moengage_flutter/moengage_flutter.dart';

class Cache {

  static late Cache _instance = Cache._internal();

  Cache._internal() {
  }

  factory Cache() => _instance;

  PushTokenCallbackHandler? pushTokenCallbackHandler;

}