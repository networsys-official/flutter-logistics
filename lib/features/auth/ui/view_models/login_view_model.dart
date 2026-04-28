import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/features/auth/providers/auth_provider.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final authData = await repository.login(email, password);
      
      // Update global session
      await ref.read(authProvider.notifier).updateSession(authData);
    });
  }
}
