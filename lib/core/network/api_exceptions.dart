import 'package:dio/dio.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';

/// Base class for all API exceptions
abstract class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Thrown when no internet connection or network fails
class NetworkException extends ApiException {
  NetworkException(super.message);
}

/// Thrown when server returns 400 Bad Request
class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.statusCode = 400});
}

/// Thrown when server returns 401 Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {super.statusCode = 401});
}

/// Thrown when server returns 403 Forbidden
class ForbiddenException extends ApiException {
  ForbiddenException(super.message, {super.statusCode = 403});
}

/// Thrown when server returns 404 Not Found
class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.statusCode = 404});
}

/// Thrown when server returns 500+ Server Error
class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode});
}

/// Helper method to map Dio exceptions to custom app exceptions
ApiException mapDioException(DioException error) {
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
    final message = _extractMessage(error.response?.data) ??
        error.message ??
        ErrorStrings.generalError;

    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 500:
      case 502:
      case 503:
        return ServerException(ErrorStrings.serverError, statusCode: statusCode);
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
