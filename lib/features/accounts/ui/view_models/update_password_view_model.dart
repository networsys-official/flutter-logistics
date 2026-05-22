import 'package:logistic_by_strom/features/accounts/data/repositories/accounts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_password_view_model.g.dart';

@riverpod
class UpdatePasswordViewModel extends _$UpdatePasswordViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(accountsRepositoryProvider)
        .updatePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}
