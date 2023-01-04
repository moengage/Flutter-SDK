
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

  static bool _isTimeStampEnabled = false;

  ///Enable/Disable TimeStamps in Logs
  static void setTimeStampLogs(bool isEnabled) {
    _isTimeStampEnabled = isEnabled;
  }

  bool _logsEnabled = true;

  ///[setLogsEnabled] enables/disables the logging in app globally
  static setLogsEnabled(bool isEnabled) {
    _logger._logsEnabled = isEnabled;
  }

  factory Logger() => _logger;

  ///Private constructor to avoid create multiple instances of logger class
  Logger._();

  ///Function [i] is for logging any information messages [tag] is an Optional positional parameter(Default tag will be appended)
  static i(dynamic message, [String tag = ""]) {
    _log(message, tag, logLevel: LogLevel.INFO);
  }

  ///Function [d] is for logging Debug-level messages
  static d(dynamic message, [String tag = ""]) {
    _log(message, tag, logLevel: LogLevel.DEBUG);
  }

  ///Function [w] is logging any warning messages. Text will be printed in Yellow color with help of ANSI escape code [\x1B[33m]
  static w(dynamic message, [String tag = ""]) {
    _log("\x1B[33m $message \x1B[0m", tag, logLevel: LogLevel.WARN);
  }

  ///Function [e] is logging error messages. Text color - Red [ANSI code - \x1B[31m].
  ///Accepts Optional named argument [error] . Error / Exception can be passed
  ///Accepts [stackTrace] argument of type [StackTrace] which can be passed from catchBlock
  ///If no Value passed the current StackTrace Will be Printed
  static e(dynamic message,
      {dynamic error, String tag = "", StackTrace? stackTrace}) {
    stackTrace ??= StackTrace.current;
    _log("\x1B[31m$message\x1B[0m", tag, error: error,
        logLevel: LogLevel.ERROR,
        stackTrace: stackTrace);
  }

  ///Function [v] is logging verbose messages
  static v(dynamic message, [String tag = ""]) {
    _log(message, tag, logLevel: LogLevel.VERBOSE);
  }

  ///Generic Function to print the log to the Flutter Console.
  static void _log(dynamic message, String tag,
      { dynamic error,
        StackTrace? stackTrace,
        LogLevel logLevel = LogLevel.DEBUG}) {
    if (!_logger._logsEnabled) {
      return;
    }
    LogResult logResult = LogResult(message, logLevel, stackTrace, error, tag);

    if (kDebugMode || kProfileMode || _logger._releaseModeLogsEnabled) {
      //log(logResult.buildMessage());
      debugPrint(logResult.buildMessage(_isTimeStampEnabled));
    }
  }
}

///Log Level to handle type of Log
enum LogLevel { VERBOSE, INFO, ERROR, DEBUG, WARN }

///Extension function to get prefix for each logs. Emojis added for easy visualization
extension Prefix on LogLevel {
  getPrefix() => name.toString()[0] + color[index];

  static final color = ["📗", "📘", "📕", "📓", "📙"];

}

/// Model class to hold log data
class LogResult {
  dynamic message;
  LogLevel logLevel;
  StackTrace? stackTrace;
  dynamic error;
  String tag;

  LogResult(this.message, this.logLevel, this.stackTrace, this.error, this.tag);

  String buildMessage(bool withTimeStamp) {
    StringBuffer resultMessage = StringBuffer();
    resultMessage
      ..write(" ${logLevel.getPrefix()}: ")
      ..write(" $BASE_TAG$tag: ")
      ..write(withTimeStamp? "${DateTime.now()} :":"")
      ..write(message.toString())
      ..write((error != null) ? "\n \x1B[31m $error \x1B[0m" : "")
      ..write((stackTrace != null) ? "\n \x1B[31m $stackTrace \x1B[0m":"");
    return resultMessage.toString();
  }
}
