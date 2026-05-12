import 'package:dio/dio.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/utils/app_logger.dart';
import 'package:logistic_by_strom/core/utils/map_utils.dart';

/// Base class for all API exceptions
abstract class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.fieldErrors = const {}});

  final String message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  String get userMessage {
    final firstFieldError = fieldErrors.values
        .where((errors) => errors.isNotEmpty)
        .map((errors) => errors.first)
        .firstOrNull;

    return firstFieldError ?? message;
  }

  String? fieldError(String fieldName) {
    final errors = fieldErrors[fieldName];
    if (errors == null || errors.isEmpty) return null;
    return errors.first;
  }

  @override
  String toString() => message;
}

/// Thrown when no internet connection or network fails
class NetworkException extends ApiException {
  NetworkException(super.message, {super.fieldErrors});
}

/// Thrown when server returns 400 Bad Request
class BadRequestException extends ApiException {
  BadRequestException(
    super.message, {
    super.statusCode = 400,
    super.fieldErrors,
  });
}

/// Thrown when server returns 401 Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException(
    super.message, {
    super.statusCode = 401,
    super.fieldErrors,
  });
}

/// Thrown when server returns 403 Forbidden
class ForbiddenException extends ApiException {
  ForbiddenException(
    super.message, {
    super.statusCode = 403,
    super.fieldErrors,
  });
}

/// Thrown when server returns 404 Not Found
class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.statusCode = 404, super.fieldErrors});
}

/// Thrown when server returns 500+ Server Error
class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode, super.fieldErrors});
}

/// Helper method to map Dio exceptions to custom app exceptions
ApiException mapDioException(DioException error) {
  final statusCode = error.response?.statusCode;
  if (statusCode == null || statusCode >= 500) {
    AppLogger.error(
      'API request failed',
      error: error,
      stackTrace: error.stackTrace,
    );
  } else {
    AppLogger.warning(
      'API request failed with status $statusCode: ${error.message}',
    );
  }

  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return NetworkException(ErrorStrings.connectionTimeout);
  }

  if (error.type == DioExceptionType.connectionError) {
    return NetworkException(ErrorStrings.noInternet);
  }

  if (error.response != null) {
    final statusCode = error.response!.statusCode;
    final data = error.response?.data;
    final message =
        _extractMessage(data) ?? error.message ?? ErrorStrings.generalError;
    final fieldErrors = _extractFieldErrors(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(message, fieldErrors: fieldErrors);
      case 401:
        return UnauthorizedException(message, fieldErrors: fieldErrors);
      case 403:
        return ForbiddenException(message, fieldErrors: fieldErrors);
      case 404:
        return NotFoundException(message, fieldErrors: fieldErrors);
      case 422:
        return BadRequestException(
          message,
          statusCode: statusCode,
          fieldErrors: fieldErrors,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          ErrorStrings.serverError,
          statusCode: statusCode,
        );
      default:
        return ServerException(message, statusCode: statusCode);
    }
  }

  return ServerException(error.message ?? ErrorStrings.unknownError);
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? data['error'] as String?;
  }
  return null;
}

Map<String, List<String>> _extractFieldErrors(dynamic data) {
  final map = MapUtils.asMap(data);
  final errors = MapUtils.asMap(map['errors']);
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
