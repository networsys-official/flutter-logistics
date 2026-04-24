import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';
import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthState> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final mockUser = AuthUser(id: '1', name: 'John Doe', email: email);
    const mockToken = 'mock_jwt_token';

    return AuthState(user: mockUser, token: mockToken);
  }

  Future<RegistrationResponse> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required int countryId,
    required int locationId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'location_id': locationId,
        'address_line_1': address.trim(),
        'password': password,
        'country_id': countryId,
      },
    );

    final data = _asMap(response.data);
    final registrationResponse = RegistrationResponse.fromJson(data);
    if (registrationResponse.userId.isEmpty) {
      throw ServerException(
        'Registration succeeded but the response format was not recognized.',
        statusCode: response.statusCode,
      );
    }

    return registrationResponse;
  }

  Future<AuthState> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {'user_id': userId, 'otp': otp},
    );

    final data = _asMap(response.data);
    final user = AuthUser.fromResponse(data);
    final token = _extractToken(data);

    if (user == null || token == null || token.isEmpty) {
      throw ServerException(
        'OTP verification succeeded but the response format was not recognized.',
        statusCode: response.statusCode,
      );
    }

    return AuthState(user: user, token: token);
  }

  Future<void> logout() async {
    // Simulated API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<String?> refreshToken(String oldToken) async {
    // Refresh must come from the backend. Do not fabricate tokens client-side.
    return null;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return const <String, dynamic>{};
  }

  String? _extractToken(Map<String, dynamic> data) {
    final directToken = data['token'] ?? data['access_token'];
    if (directToken is String && directToken.isNotEmpty) {
      return directToken;
    }

    final nestedData = _asMap(data['data']);
    final nestedToken = nestedData['token'] ?? nestedData['access_token'];
    if (nestedToken is String && nestedToken.isNotEmpty) {
      return nestedToken;
    }

    final auth = _asMap(data['auth']);
    final authToken = auth['token'] ?? auth['access_token'];
    if (authToken is String && authToken.isNotEmpty) {
      return authToken;
    }

    return null;
  }
}
