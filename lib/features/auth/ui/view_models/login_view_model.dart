import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/features/auth/data/models/login_request.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:url_launcher/url_launcher.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    final url = Uri.parse(ApiEndpoints.googleRedirectUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Could not launch Google Sign In.', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.login(
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
