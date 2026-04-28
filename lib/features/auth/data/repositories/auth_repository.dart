import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';

abstract interface class AuthRepository {
  Future<AuthState> login(String email, String password);
  
  Future<RegistrationResponse> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required int countryId,
    required int locationId,
  });

  Future<AuthState> verifyOtp({
    required String userId,
    required String otp,
  });

  Future<void> logout();

  Future<String?> refreshToken(String oldToken);
}
