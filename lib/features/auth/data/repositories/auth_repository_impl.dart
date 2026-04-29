import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';
import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';
import 'package:logistic_by_strom/features/auth/data/models/user_model.dart';
import 'package:logistic_by_strom/features/auth/data/models/login_request.dart';
import 'package:logistic_by_strom/features/auth/data/models/register_request.dart';
import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthState> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final mockUser = UserModel(id: '1', name: 'John Doe', email: request.email);
    const mockToken = 'mock_jwt_token';

    return AuthState(user: mockUser, token: mockToken);
  }

  @override
  Future<RegistrationResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'name': request.name.trim(),
        'email': request.email.trim(),
        'phone': request.phone.trim(),
        'location_id': request.locationId,
        'address_line_1': request.address.trim(),
        'password': request.password,
        'country_id': request.countryId,
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

  @override
  Future<void> sendOtp({
    required String identifier,
    required String type,
  }) async {
    await _apiClient.post(
      ApiEndpoints.resendOtp,
      data: {
        'identifier': identifier.trim(),
        'type': type,
      },
    );
  }

  @override
  Future<AuthState> verifyOtp({
    required String identifier,
    required String type,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {
        'identifier': identifier.trim(),
        'type': type,
        'otp': otp,
      },
    );

    final data = _asMap(response.data);
    final user = UserModel.fromJson(_asMap(data['user']));
    final token = data['access_token'] as String?;

    return AuthState(user: user, token: token);
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {

    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      ApiEndpoints.forgetPassword,
      data: {
        'email': email.trim()
      },
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    await _apiClient.post(
      ApiEndpoints.restPassword,
      data: {
        'email': email.trim(),
        'token': token,
        'password': newPassword,
      },
    );
  }

  @override
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
}
