import 'package:dio/dio.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/errors/app_failure.dart';
import 'package:logistic_by_strom/core/errors/failure_code.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';
import 'package:logistic_by_strom/core/utils/app_logger.dart';

class ErrorMapper {
  const ErrorMapper._();

  static AppFailure map(Object error, StackTrace stackTrace) {
    if (error is ApiException && (error.statusCode != null && error.statusCode! < 500)) {
      AppLogger.warning('Operation failed: ${error.message}');
    } else {
      AppLogger.error('Operation failed', error: error, stackTrace: stackTrace);
    }

    if (error is ApiException) {
      return _mapApiException(error);
    }

    if (error is DioException) {
      return _mapDioException(error);
    }

    return const AppFailure(
      message: ErrorStrings.somethingWentWrong,
      code: FailureCode.unknownError,
    );
  }

  static AppFailure _mapApiException(ApiException error) {
    if (error is NetworkException) {
      final isTimeout = error.message == ErrorStrings.connectionTimeout;
      return AppFailure(
        message: isTimeout
            ? ErrorStrings.serverNotResponding
            : ErrorStrings.noInternetFriendly,
        code: isTimeout ? FailureCode.timeoutError : FailureCode.networkError,
        statusCode: error.statusCode,
      );
    }

    if (error.fieldErrors.isNotEmpty) {
      return AppFailure(
        message: error.userMessage,
        code: FailureCode.validationError,
        statusCode: error.statusCode,
        fieldErrors: error.fieldErrors,
      );
    }

    return AppFailure(
      message: error.userMessage.isNotEmpty ? error.userMessage : _messageForStatusCode(error.statusCode),
      code: _codeForStatusCode(error.statusCode),
      statusCode: error.statusCode,
    );
  }

  static AppFailure _mapDioException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const AppFailure(
        message: ErrorStrings.serverNotResponding,
        code: FailureCode.timeoutError,
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const AppFailure(
        message: ErrorStrings.noInternetFriendly,
        code: FailureCode.networkError,
      );
    }

    final statusCode = error.response?.statusCode;
    final fieldErrors = _extractFieldErrors(error.response?.data);
    if (fieldErrors.isNotEmpty) {
      return AppFailure(
        message: _firstFieldError(fieldErrors),
        code: FailureCode.validationError,
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      );
    }

    return AppFailure(
      message: _messageForStatusCode(statusCode),
      code: _codeForStatusCode(statusCode),
      statusCode: statusCode,
    );
  }

  static String _messageForStatusCode(int? statusCode) {
    switch (statusCode) {
      case 401:
        return ErrorStrings.sessionExpired;
      case 400:
      case 422:
        return ErrorStrings.validationFailedFriendly;
      case 500:
      case 502:
      case 503:
        return ErrorStrings.serverNotResponding;
      default:
        return ErrorStrings.somethingWentWrong;
    }
  }

  static String _codeForStatusCode(int? statusCode) {
    switch (statusCode) {
      case 401:
        return FailureCode.unauthorized;
      case 400:
      case 422:
        return FailureCode.validationError;
      case 500:
      case 502:
      case 503:
        return FailureCode.serverError;
      default:
        return FailureCode.unknownError;
    }
  }

  static Map<String, List<String>> _extractFieldErrors(dynamic data) {
    final map = _asMap(data);
    final errors = _asMap(map['errors']);
    if (errors.isEmpty) return const {};

    return errors.map((field, value) {
      if (value is List) {
        return MapEntry(
          field,
          value.map((error) => error.toString()).toList(growable: false),
        );
      }

      return MapEntry(field, [value.toString()]);
    });
  }

  static String _firstFieldError(Map<String, List<String>> fieldErrors) {
    return fieldErrors.values
            .where((errors) => errors.isNotEmpty)
            .map((errors) => errors.first)
            .firstOrNull ??
        ErrorStrings.validationFailedFriendly;
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return const {};
  }
}
