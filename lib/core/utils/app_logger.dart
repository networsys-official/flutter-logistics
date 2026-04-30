import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'logistic_by_strom',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
