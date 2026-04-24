import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';
import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthState> login(String email, String password) async {

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

    required int countryId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'mobile': mobile.trim(),
        'address': address.trim(),
        'password': password,
        'country_id': countryId,
      },
    );

    final data = _asMap(response.data);
    final token = _extractToken(data);
    final user = _extractUser(data);

    if (user == null && token == null) {
      throw ServerException(
        'Registration succeeded but the response format was not recognized.',
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
    // Simulated refresh
    await Future.delayed(const Duration(seconds: 1));
    return 'new_mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
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

  AuthUser? _extractUser(Map<String, dynamic> data) {
    final rawUser =
        data['user'] ??
        _asMap(data['data'])['user'] ??
        _asMap(data['data'])['customer'] ??
        data['customer'];

    final userMap = _asMap(rawUser);
    if (userMap.isNotEmpty) {
      return _authUserFromMap(userMap);
    }

    if (data['id'] != null || data['name'] != null || data['email'] != null) {
      return _authUserFromMap(data);
    }

    final nestedData = _asMap(data['data']);
    if (nestedData['id'] != null ||
        nestedData['name'] != null ||
        nestedData['email'] != null) {
      return _authUserFromMap(nestedData);
    }

    return null;
  }

  AuthUser _authUserFromMap(Map<String, dynamic> value) {
    final id =
        value['id'] ??
        value['user_id'] ??
        value['customer_id'] ??
        value['uuid'];
    final name =
        value['name'] ??
        value['full_name'] ??
        value['username'] ??
        value['first_name'];
    final email = value['email'] ?? value['email_address'];
    final photoUrl = value['photo_url'] ?? value['photoUrl'] ?? value['avatar'];

    return AuthUser(
      id: '${id ?? ''}',
      name: '${name ?? ''}',
      email: '${email ?? ''}',
      photoUrl: photoUrl is String && photoUrl.isNotEmpty ? photoUrl : null,
    );
  }
}
