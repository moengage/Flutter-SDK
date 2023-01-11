
import 'package:flutter/foundation.dart';

const BASE_TAG = "MoEFlutter_";

///Logger Util Class to print logs to the Flutter Console
class Logger {
  static final Logger _logger = Logger._();

  ///Flag to handle logs in Release build. By default logs in release mode will be disabled.
  bool _releaseModeLogsEnabled = false;

  /// [setReleaseModeLogsEnabled] enables/disables the logging in Release builds based on [isEnabled] flag
  static setReleaseModeLogsEnabled(bool isEnabled) {
    _logger._releaseModeLogsEnabled = isEnabled;
  }

  bool _logsEnabled = true;

  ///[setLogsEnabled] enables/disables the logging in app globally
  static setLogsEnabled(bool isEnabled) {
    _logger._logsEnabled = isEnabled;
  }

  factory Logger() => _logger;

  ///Private constructor to avoid create multiple instances of logger class
  Logger._();

  ///Function [i] is for logging any information messages
  static i(String message) {
    _log("I: $BASE_TAG$message", logLevel: LogLevel.INFO);
  }

  ///Function [d] is for logging Debug-level messages
  static d(String message) {
    _log("D: $BASE_TAG$message", logLevel: LogLevel.DEBUG);
  }

  ///Function [w] is logging any warning messages. Text will be printed in Yellow color with help of ANSI escape code [\x1B[33m]
  static w(String message) {
    _log("W: $BASE_TAG$message", logLevel: LogLevel.WARN,textColor: "\x1B[33m");
  }

  ///Function [e] is logging error messages. Text color - Red [ANSI code - \x1B[31m].
  ///Accepts Optional named argument [error] . Error / Exception can be passed
  ///Optional [stackTrace] argument of type [StackTrace] which can be passed from catch Block
  static e(String message,
      {dynamic error, StackTrace? stackTrace}) {
    _log("E: $BASE_TAG$message", error: error,
        logLevel: LogLevel.ERROR,
        stackTrace: stackTrace,textColor:"\x1B[31m");
  }

  ///Function [v] is logging verbose messages
  static v(String message) {
    _log("V: $BASE_TAG$message", logLevel: LogLevel.VERBOSE);
  }

  ///Generic Function to print the log to the Flutter Console.
  static void _log(String message,
      { dynamic error,
        StackTrace? stackTrace,
        LogLevel logLevel = LogLevel.DEBUG, String? textColor}) {
    if (!_logger._logsEnabled) {
      return;
    }
    LogResult logResult = LogResult(message, logLevel, stackTrace, error,textColor);

    if (kDebugMode || kProfileMode || _logger._releaseModeLogsEnabled) {
      debugPrint(logResult.buildMessage());
    }
  }
}

///Log Level to handle type of Log
enum LogLevel { VERBOSE, INFO, ERROR, DEBUG, WARN }

/// Model class to hold log data
class LogResult {
  String message;
  LogLevel logLevel;
  StackTrace? stackTrace;
  dynamic error;
  String? textColor;

  LogResult(this.message, this.logLevel, this.stackTrace, this.error,this.textColor);

  String buildMessage() {
    StringBuffer resultMessage = StringBuffer();
    resultMessage
      ..write(textColor??"")
      ..write("${DateTime.now()} ")
      ..write(message.toString())
      ..write(error ?? "")
      ..write(stackTrace??"")
      ..write((textColor!=null) ?"\x1B[0m":"");
    return resultMessage.toString();
  }
}
