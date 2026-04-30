import 'package:flutter_test/flutter_test.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';

void main() {
  group('RegistrationResponse', () {
    test('reads user id from nested data.user_id', () {
      final response = RegistrationResponse.fromJson(const {
        'success': true,
        'message': 'Registration successful',
        'data': {'user_id': 'user-1'},
      });

      expect(response.userId, 'user-1');
      expect(response.message, 'Registration successful');
    });

    test('reads user id from nested data.user.id', () {
      final response = RegistrationResponse.fromJson(const {
        'success': true,
        'message': 'Registration successful',
        'data': {
          'user': {'id': '019dd91d-8300-7265-8195-497bd5873fa6'},
        },
      });

      expect(response.userId, '019dd91d-8300-7265-8195-497bd5873fa6');
      expect(response.message, 'Registration successful');
    });
  });
}
