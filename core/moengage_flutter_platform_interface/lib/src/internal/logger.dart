import 'package:flutter/foundation.dart';

import '../log_level.dart';

/// Base Tag for Logger
const String BASE_TAG = 'MoEFlutter';

///Logger Util Class to print logs to the Flutter Console
class Logger {
  /// Factory Constructor
  factory Logger() => _logger;

  Logger._();
  static final Logger _logger = Logger._();

  ///Flag to handle logs in Release build. By default logs in release mode will be disabled.
  bool _isEnabledForReleaseBuild = false;

  ///LogLevel for SDK logs.
  LogLevel _logLevel = LogLevel.INFO;

  /// Configure MoEngage SDK Logs
  /// [logLevel] - [LogLevel] Control for SDK logs
  /// [isEnabledForReleaseBuild] If true, logs will be printed for the Release build. By default the logs are disabled for the Release build.
  static void configureLogs(LogLevel logLevel,
      [bool isEnabledForReleaseBuild = false]) {
    _logger._logLevel = logLevel;
    _logger._isEnabledForReleaseBuild = isEnabledForReleaseBuild;
  }

  ///Logs INFO level messages
  ///[message] message to be logged
  static void i(String message) {
    _log('[I]: $BASE_TAG $message', logLevel: LogLevel.INFO);
  }

  ///Logs DEBUG level messages
  ///[message] message to be logged
  static void d(String message) {
    _log('[D]: $BASE_TAG $message', logLevel: LogLevel.DEBUG);
  }

  ///Logs WARN level messages.
  ///[message] message to be logged
  static void w(String message) {
    _log('[W]: $BASE_TAG $message',
        logLevel: LogLevel.WARN, textColor: '\x1B[33m');
  }

  ///Logs ERROR level messages.
  ///[message] message to be logged
  ///[error] optional named argument of type [Error]/[Exception].
  ///[stackTrace] optional named argument [StackTrace]
  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _log('[E]: $BASE_TAG $message',
        error: error,
        logLevel: LogLevel.ERROR,
        stackTrace: stackTrace,
        textColor: '\x1B[31m');
  }

  ///Logs VERBOSE level messages
  ///[message] message to be logged
  static void v(String message) {
    _log('[V]: $BASE_TAG $message', logLevel: LogLevel.VERBOSE);
  }

  static void _log(String message,
      {dynamic error,
      StackTrace? stackTrace,
      required LogLevel logLevel,
      String? textColor}) {
    if (_logger._logLevel.index < logLevel.index) {
      return;
    }
    if (kDebugMode || kProfileMode || _logger._isEnabledForReleaseBuild) {
      debugPrint(
          _buildMessage(message, logLevel, stackTrace, error, textColor));
    }
  }

  static String _buildMessage(String message, LogLevel logLevel,
      StackTrace? stackTrace, dynamic error, String? textColor) {
    final StringBuffer resultMessage = StringBuffer();
    resultMessage
      ..write(textColor ?? '')
      ..write('${DateTime.now()} ')
      ..write(message)
      ..write(error ?? '')
      ..write(stackTrace ?? '')
      ..write((textColor != null) ? '\x1B[0m' : '');
    return resultMessage.toString();
  }
}
