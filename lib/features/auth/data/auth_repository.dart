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
    required int locationId
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
    final user = AuthUser.fromResponse(data);

    if (user == null) {
      throw ServerException(
        'Registration succeeded but the response format was not recognized.',
        statusCode: response.statusCode,
      );
    }

    return RegistrationResponse(
      user: user,
      message: _extractMessage(data),
      otpRequired: true,
    );
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

  String? _extractMessage(Map<String, dynamic> data) {
    final directMessage = data['message'];
    if (directMessage is String && directMessage.isNotEmpty) {
      return directMessage;
    }

    final nestedData = _asMap(data['data']);
    final nestedMessage = nestedData['message'];
    if (nestedMessage is String && nestedMessage.isNotEmpty) {
      return nestedMessage;
    }

    return null;
  }
}
