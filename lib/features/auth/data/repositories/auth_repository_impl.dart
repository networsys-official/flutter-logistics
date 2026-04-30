import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/network/api_exceptions.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';
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
  ResultFuture<AuthState> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': request.email.trim(), 'password': request.password},
      );

      return right(_authStateFromResponse(response.data, response.statusCode));
    } catch (error, stackTrace) {
      return left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultFuture<RegistrationResponse> register(RegisterRequest request) async {
    try {
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

      return right(registrationResponse);
    } catch (error, stackTrace) {
      return left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultVoid sendOtp({required String identifier, required String type}) async {
    try {
      await _apiClient.post(
        ApiEndpoints.resendOtp,
        data: {'identifier': identifier.trim(), 'type': type},
      );
      return right(null);
    } catch (error, stackTrace) {
      return left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultFuture<AuthState> verifyOtp({
    required String identifier,
    required String type,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {'identifier': identifier.trim(), 'type': type, 'otp': otp},
      );

      final data = _asMap(response.data);
      final user = UserModel.fromJson(_asMap(data['user']));
      final token = data['access_token'] as String?;

      return right(AuthState(user: user, token: token));
    } catch (error, stackTrace) {
      return left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultVoid logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (error, stackTrace) {
      ErrorMapper.map(error, stackTrace);
    }
    return right(null);
  }

  @override
  ResultVoid forgotPassword(String email) async {
    try {
      await _apiClient.post(
        ApiEndpoints.forgetPassword,
        data: {'email': email.trim()},
      );
      return right(null);
    } catch (error, stackTrace) {
      return left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultVoid resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.restPassword,
        data: {'email': email.trim(), 'token': token, 'password': newPassword},
      );
      return right(null);
    } catch (error, stackTrace) {
      return left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultFuture<String?> refreshToken(String oldToken) async {
    // Refresh must come from the backend. Do not fabricate tokens client-side.
    return right(null);
  }

  AuthState _authStateFromResponse(dynamic responseData, int? statusCode) {
    final data = _asMap(responseData);
    final payload = _asMap(data['data']).isNotEmpty
        ? _asMap(data['data'])
        : data;
    final userData = _asMap(payload['user']);
    final token = _readToken(payload);

    if (userData.isEmpty || token == null || token.isEmpty) {
      throw ServerException(
        'Login succeeded but the response format was not recognized.',
        statusCode: statusCode,
      );
    }

    return AuthState(user: UserModel.fromJson(userData), token: token);
  }

  String? _readToken(Map<String, dynamic> data) {
    final token =
        data['access_token'] ??
        data['token'] ??
        data['auth_token'] ??
        data['jwt'];

    return token is String && token.isNotEmpty ? token : null;
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
