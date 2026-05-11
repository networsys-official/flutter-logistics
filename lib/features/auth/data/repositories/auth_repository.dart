import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/core/models/auth_state.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';
import 'package:logistic_by_strom/features/auth/data/models/login_request.dart';
import 'package:logistic_by_strom/features/auth/data/models/register_request.dart';

abstract interface class AuthRepository {
  ResultFuture<AuthState> login(LoginRequest request);

  ResultFuture<RegistrationResponse> register(RegisterRequest request);

  ResultVoid sendOtp({required String identifier, required String type});

  ResultFuture<AuthState> verifyOtp({
    required String identifier,
    required String type,
    required String otp,
  });

  ResultVoid logout();

  ResultVoid forgotPassword(String email);

  ResultVoid resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  ResultFuture<String?> refreshToken(String oldToken);
}
