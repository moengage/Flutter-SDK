import 'package:flutter/foundation.dart';

const BASE_TAG = "MoEFlutter";

///Logger Util Class to print logs to the Flutter Console
class Logger {
  static final Logger _logger = Logger._();

  ///Flag to handle logs in Release build. By default logs in release mode will be disabled.
  bool _isEnabledForReleaseBuild = false;

  LogLevel _logLevel = LogLevel.VERBOSE;

  /// Configure MoEngage SDK Logs
  /// @param [logLevel] LogLevel for SDK logs
  /// @param [isEnabledForReleaseBuild] To enable/disable logs in Release build.
  static configureLogs(LogLevel logLevel,
      [bool isEnabledForReleaseBuild = false]) {
    _logger._logLevel = logLevel;
    _logger._isEnabledForReleaseBuild = isEnabledForReleaseBuild;
  }

  factory Logger() => _logger;

  ///Private constructor to avoid create multiple instances of logger class
  Logger._();

  ///Function [i] is for logging any information messages
  static i(String message) {
    _log("[I]: $BASE_TAG $message", logLevel: LogLevel.INFO);
  }

  ///Function [d] is for logging Debug-level messages
  static d(String message) {
    _log("[D]: $BASE_TAG $message", logLevel: LogLevel.DEBUG);
  }

  ///Function [w] is logging any warning messages. Text will be printed in Yellow color with help of ANSI escape code [\x1B[33m]
  static w(String message) {
    _log("[W]: $BASE_TAG $message",
        logLevel: LogLevel.WARN, textColor: "\x1B[33m");
  }

  ///Function [e] is logging error messages. Text color - Red [ANSI code - \x1B[31m].
  ///Accepts Optional named argument [error] . Error / Exception can be passed
  ///Optional [stackTrace] argument of type [StackTrace] which can be passed from catch Block
  static e(String message, {dynamic error, StackTrace? stackTrace}) {
    _log("[E]: $BASE_TAG $message",
        error: error,
        logLevel: LogLevel.ERROR,
        stackTrace: stackTrace,
        textColor: "\x1B[31m");
  }

  ///Function [v] is logging verbose messages
  static v(String message) {
    _log("[V]: $BASE_TAG $message", logLevel: LogLevel.VERBOSE);
  }

  ///Generic Function to print the log to the Flutter Console.
  static void _log(String message,
      {dynamic error,
        StackTrace? stackTrace,
        LogLevel logLevel = LogLevel.VERBOSE,
        String? textColor}) {
    if (_logger._logLevel.index < logLevel.index) {
      return;
    }
    if (kDebugMode || kProfileMode || _logger._isEnabledForReleaseBuild) {
      LogResult logResult =
      LogResult(message, logLevel, stackTrace, error, textColor);
      debugPrint(logResult.buildMessage());
    }
  }
}

///Log Level to handle type of Log
enum LogLevel { NO_LOG, ERROR, WARN, INFO, DEBUG, VERBOSE }

/// Model class to hold log data
class LogResult {
  String message;
  LogLevel logLevel;
  StackTrace? stackTrace;
  dynamic error;
  String? textColor;

  LogResult(this.message, this.logLevel, this.stackTrace, this.error,
      this.textColor);

  String buildMessage() {
    StringBuffer resultMessage = StringBuffer();
    resultMessage..write(textColor ?? "")..write("${DateTime.now()} ")..write(
        message.toString())..write(error ?? "")..write(stackTrace ?? "")..write(
        (textColor != null) ? "\x1B[0m" : "");
    return resultMessage.toString();
  }
}
