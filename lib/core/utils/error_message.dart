import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/errors/app_failure.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';

String errorMessageFrom(Object error, {String? fallback}) {
  if (error is AppFailure) {
    return error.message;
  }

  if (error is ApiException) {
    return error.userMessage;
  }

  return fallback ?? ErrorStrings.somethingWentWrong;
}

String? fieldErrorFrom(Object? error, String fieldName) {
  if (error is AppFailure) {
    return error.fieldError(fieldName);
  }

  if (error is ApiException) {
    return error.fieldError(fieldName);
  }

  return null;
}
