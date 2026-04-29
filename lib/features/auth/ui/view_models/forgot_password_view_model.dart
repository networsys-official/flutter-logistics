import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/features/auth/providers/auth_provider.dart';

part 'forgot_password_view_model.g.dart';

@riverpod
class ForgotPasswordViewModel extends _$ForgotPasswordViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    bool success = false;
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.forgotPassword(email);
      success = true;
    });
    
    return success;
  }

  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    bool success = false;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
      );
      success = true;
    });

    return success;
  }
}
