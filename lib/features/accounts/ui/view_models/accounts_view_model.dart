import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/accounts_repository.dart';

part 'accounts_view_model.g.dart';

@riverpod
AccountsRepository accountsRepository(Ref ref) {
  return AccountsRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(storageServiceProvider.notifier),
  );
}

@riverpod
class AccountsViewModel extends _$AccountsViewModel {
  @override
  FutureOr<UserProfile?> build() async {
    final repository = ref.read(accountsRepositoryProvider);
    final result = await repository.getProfile();

    return result.fold((failure) => throw failure, (profile) => profile);
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    final result = await ref.read(accountsRepositoryProvider).getProfile();
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (profile) => AsyncValue.data(profile),
    );
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? gender,
    String? dob,
    String? language,
    String? imagePath,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(accountsRepositoryProvider)
        .updateProfile(
          name: name,
          phone: phone,
          gender: gender,
          dob: dob,
          language: language,
          imagePath: imagePath,
        );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (profile) {
        state = AsyncValue.data(profile);
        return true;
      },
    );
  }
}
