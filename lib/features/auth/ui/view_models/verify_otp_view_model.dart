import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';

part 'verify_otp_view_model.g.dart';

@riverpod
class VerifyOtpViewModel extends _$VerifyOtpViewModel {
  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> verifyOtp({
    required String identifier,
    required String type,
    required String otp,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRepo.verifyOtp(
      identifier: identifier,
      type: type,
      otp: otp,
    );

    await result.match(
      (failure) async {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (authData) async {
        try {
          // Update global session ONLY for registration/login verification
          if (type != 'forgot_password') {
            await ref.read(authProvider.notifier).updateSession(authData);
          }
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

  Future<void> resendOtp({
    required String identifier,
    required String type,
  }) async {
    state = const AsyncValue.loading();
    final result = await _authRepo.sendOtp(identifier: identifier, type: type);

    result.match(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        state = const AsyncValue.data(null);
      },
    );
  }
}
