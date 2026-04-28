import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';
import 'package:logistic_by_strom/features/auth/data/models/login_request.dart';
import 'package:logistic_by_strom/features/auth/data/models/register_request.dart';

abstract interface class AuthRepository {
  Future<AuthState> login(LoginRequest request);
  
  Future<RegistrationResponse> register(RegisterRequest request);

  Future<void> sendOtp({required String identifier, required String type});

  Future<AuthState> verifyOtp({
    required String identifier,
    required String type,
    required String otp,
  });

  Future<void> logout();

  Future<String?> refreshToken(String oldToken);
}
