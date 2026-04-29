import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/features/auth/providers/auth_provider.dart';

part 'verify_otp_view_model.g.dart';

@riverpod
class VerifyOtpViewModel extends _$VerifyOtpViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> verifyOtp({
    required String identifier,
    required String type,
    required String otp,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final authData = await repository.verifyOtp(
        identifier: identifier,
        type: type,
        otp: otp,
      );
      
      // Update global session ONLY for registration/login verification
      if (type != 'forgot_password') {
        await ref.read(authProvider.notifier).updateSession(authData);
      }
    });
  }

  Future<void> resendOtp({
    required String identifier,
    required String type,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendOtp(identifier: identifier, type: type);
    });
  }
}
