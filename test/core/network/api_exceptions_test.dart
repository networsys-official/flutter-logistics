import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';

void main() {
  group('mapDioException', () {
    test('extracts validation field errors from API response', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/forgot-password'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/forgot-password'),
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
      );

      expect(exception, isA<BadRequestException>());
      expect(exception.message, 'Validation failed');
      expect(exception.statusCode, 422);
      expect(
        exception.fieldError('email'),
        'We could not find a user with that email address.',
      );
      expect(
        exception.userMessage,
        'We could not find a user with that email address.',
      );
      expect(exception.toString(), 'Validation failed');
    });
  });
}
