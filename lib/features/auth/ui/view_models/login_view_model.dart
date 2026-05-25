import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/features/auth/data/models/login_request.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await _authRepo.launchGoogleSignIn();
    result.match(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    final result = await _authRepo.login(
      LoginRequest(email: email, password: password),
    );

    await result.match(
      (failure) async {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (authData) async {
        try {
          await ref.read(authProvider.notifier).updateSession(authData);
          state = const AsyncValue.data(null);
        } catch (error, stackTrace) {
          state = AsyncValue.error(
            ErrorMapper.map(error, stackTrace),
            stackTrace,
          );
        }
      },
    );
  }
}
