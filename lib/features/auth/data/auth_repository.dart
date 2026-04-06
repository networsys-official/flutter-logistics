import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';


class AuthRepository {
  AuthRepository(this._apiClient);

  // ignore: unused_field
  final ApiClient _apiClient;

  Future<AuthState> login(String email, String password) async {
    // Simulated API call via ApiClient wrapper
    // In real app: final response = await _apiClient.post(ApiEndpoints.login, data: {...});
    await Future.delayed(const Duration(seconds: 1));

    final mockUser = AuthUser(id: '1', name: 'John Doe', email: email);
    const mockToken = 'mock_jwt_token';

    return AuthState(user: mockUser, token: mockToken);
  }

  Future<AuthState> register({
    required String name,
    required String email,
    required String mobile,
    required String address,
    required String password,
    required String addressType,
    required int countryId
  }) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));

    final mockUser = AuthUser(id: '1', name: name, email: email);
    const mockToken = 'mock_jwt_token_new_user';

    return AuthState(user: mockUser, token: mockToken);
  }

  Future<void> logout() async {
    // Simulated API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<String?> refreshToken(String oldToken) async {
    // Simulated refresh
    await Future.delayed(const Duration(seconds: 1));
    return 'new_mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}
