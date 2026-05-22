import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/core/models/user_model.dart';
import 'package:logistic_by_strom/core/models/auth_state.dart';

part 'social_auth_callback_view_model.g.dart';

@riverpod
class SocialAuthCallbackViewModel extends _$SocialAuthCallbackViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> handleCallback({
    required String? token,
    required String? userJson,
  }) async {
    if (token == null || token.isEmpty || userJson == null || userJson.isEmpty) {
      state = AsyncValue.error(
        'Authentication failed: Invalid credentials returned.',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      final user = UserModel.fromJson(userData);
      final authState = AuthState(user: user, token: token);

      await ref.read(authProvider.notifier).updateSession(authState);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        'Failed to parse user details: ${e.toString()}',
        stackTrace,
      );
    }
  }
}
