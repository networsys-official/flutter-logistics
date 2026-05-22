import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forgot_password_view_model.g.dart';

@riverpod
class ForgotPasswordViewModel extends _$ForgotPasswordViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> forgotPassword(String email) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.forgotPassword(email);

    var success = false;
    result.match(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        success = true;
        state = const AsyncValue.data(null);
      },
    );

    return success;
  }

  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    var success = false;

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
    );

    result.match(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        success = true;
        state = const AsyncValue.data(null);
      },
    );

    return success;
  }
}
