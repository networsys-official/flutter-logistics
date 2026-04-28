import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository.dart';
import 'package:logistic_by_strom/features/auth/data/models/user_model.dart';
import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() async {
    final storage = ref.read(storageServiceProvider.notifier);
    final token = await storage.getToken();
    final userJson = await storage.getUser();

    if (token != null && userJson != null) {
      try {
        final user = UserModel.fromJson(jsonDecode(userJson));
        return AuthState(user: user, token: token);
      } catch (_) {
        await _clearStorage();
        return const AuthState();
      }
    }

    return const AuthState();
  }

  /// Updates the global session state and persists it.
  Future<void> updateSession(AuthState authData) async {
    await _persistAuthData(authData);
    state = AsyncValue.data(authData);
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    await _clearStorage();
    state = const AsyncValue.data(AuthState());
  }

  Future<void> _persistAuthData(AuthState authData) async {
    if (authData.token != null && authData.user != null) {
      final storage = ref.read(storageServiceProvider.notifier);
      await storage.saveToken(authData.token!);
      await storage.saveUser(jsonEncode(authData.user!.toJson()));
    }
  }

  Future<void> _clearStorage() async {
    final storage = ref.read(storageServiceProvider.notifier);
    await storage.deleteToken();
    await storage.deleteUser();
  }
}
