import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loggingServiceProvider = Provider<LoggingService>((ref) {
  return LoggingService();
});

class LoggingService {
  final Logger _logger;

  LoggingService()
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            printTime: true,
          ),
        );

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error: error, stackTrace: stackTrace);
  }

  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error: error, stackTrace: stackTrace);
  }

  void logApiRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) {
    _logger.i(
      'API Request',
      error: {
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
      },
    );
  }

  void logApiResponse({
    required String method,
    required String url,
    required int statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    _logger.i(
      'API Response',
      error: {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'headers': headers,
        'body': body,
      },
    );
  }

  void logApiError({
    required String method,
    required String url,
    required int statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      'API Error',
      error: {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'headers': headers,
        'body': body,
        'error': error,
      },
      stackTrace: stackTrace,
    );
  }

  void logNavigation({
    required String from,
    required String to,
    Map<String, dynamic>? arguments,
  }) {
    _logger.i(
      'Navigation',
      error: {
        'from': from,
        'to': to,
        'arguments': arguments,
      },
    );
  }

  void logUserAction({
    required String action,
    required String userId,
    Map<String, dynamic>? data,
  }) {
    _logger.i(
      'User Action',
      error: {
        'action': action,
        'userId': userId,
        'data': data,
      },
    );
  }

  void logStateChange({
    required String stateName,
    required String oldState,
    required String newState,
    Map<String, dynamic>? data,
  }) {
    _logger.i(
      'State Change',
      error: {
        'stateName': stateName,
        'oldState': oldState,
        'newState': newState,
        'data': data,
      },
    );
  }
}
