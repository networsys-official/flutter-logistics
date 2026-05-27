import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository.dart';
import 'package:logistic_by_strom/core/services/notification_service.dart';

import 'package:logistic_by_strom/core/models/user_model.dart';
import 'package:logistic_by_strom/core/models/auth_state.dart';

import 'package:logistic_by_strom/core/providers/session_provider.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() async {
    final storage = ref.watch(storageServiceProvider.notifier);

    ref.listen(sessionProvider, (previous, next) {
      if (next > 0) {
        logout();
      }
    });

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
    
    // Explicitly sync the FCM token to the server now that we are logged in
    try {
      await ref.read(notificationServiceProvider.notifier).getAndSyncToken();
    } catch (_) {
      // Ignored
    }
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    try {
      await ref.read(notificationServiceProvider.notifier).deleteTokenFromServer();
    } catch (_) {
      // Ignored: proceed with local logout regardless of API success
    }
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
