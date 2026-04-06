import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/features/auth/data/auth_repository.dart';
import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';

part 'auth_view_model.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<AuthState> build() async {
    final storage = ref.read(storageServiceProvider.notifier);
    final token = await storage.getToken();
    final userJson = await storage.getUser();

    if (token != null && userJson != null) {
      try {
        final user = AuthUser.fromJson(jsonDecode(userJson));
        return AuthState(user: user, token: token);
      } catch (_) {
        await _clearStorage();
        return const AuthState();
      }
    }

    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final authData = await repository.login(email, password);
      await _persistAuthData(authData);
      return authData;
    });
  }

  Future<void> register({
    required String name,
    required String email,
    required String mobile,
    required String address,
    required String password,
    required String addressType,
    required int countryId,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final authData = await repository.register(
        name: name,
        email: email,
        mobile: mobile,
        address: address,
        password: password,
        addressType: addressType,
        countryId: countryId,
      );
      await _persistAuthData(authData);
      return authData;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      await _clearStorage();
      return const AuthState();
    });
  }

  Future<void> refreshToken() async {
    final currentToken = state.value?.token;
    if (currentToken == null) return;

    final repository = ref.read(authRepositoryProvider);
    final newToken = await repository.refreshToken(currentToken);

    if (newToken != null) {
      final storage = ref.read(storageServiceProvider.notifier);
      await storage.saveToken(newToken);
      state = AsyncValue.data(state.value!.copyWith(token: newToken));
    } else {
      await logout();
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

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
