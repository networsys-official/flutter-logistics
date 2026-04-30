import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/core/errors/failure_code.dart';

void main() {
  group('ErrorMapper', () {
    test('maps validation responses to a user-friendly failure', () {
      final failure = ErrorMapper.map(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/register'),
            statusCode: 422,
            data: const {
              'success': false,
              'message': 'Validation failed',
              'errors': {
                'email': ['We could not find a user with that email address.'],
              },
            },
          ),
        ),
        StackTrace.current,
      );

      expect(
        failure.message,
        'We could not find a user with that email address.',
      );
      expect(failure.code, FailureCode.validationError);
      expect(failure.statusCode, 422);
      expect(
        failure.fieldError('email'),
        'We could not find a user with that email address.',
      );
      expect(
        failure.toString(),
        'We could not find a user with that email address.',
      );
    });

    test('maps invalid credentials field errors even when status is 401', () {
      final failure = ErrorMapper.map(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 401,
            data: const {
              'success': false,
              'message': 'Invalid credentials',
              'errors': {
                'email': ['Invalid credentials'],
              },
            },
          ),
        ),
        StackTrace.current,
      );

      expect(failure.message, 'Invalid credentials');
      expect(failure.code, FailureCode.validationError);
      expect(failure.statusCode, 401);
      expect(failure.fieldError('email'), 'Invalid credentials');
    });

    test('maps connection failures to a network failure', () {
      final failure = ErrorMapper.map(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          type: DioExceptionType.connectionError,
        ),
        StackTrace.current,
      );

      expect(failure.message, ErrorStrings.noInternetFriendly);
      expect(failure.code, FailureCode.networkError);
    });
  });
}
