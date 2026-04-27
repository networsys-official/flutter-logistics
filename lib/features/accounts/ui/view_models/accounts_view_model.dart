import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/accounts_repository.dart';

part 'accounts_view_model.g.dart';

@riverpod
AccountsRepository accountsRepository(Ref ref) {
  return AccountsRepository();
}

@riverpod
class AccountsViewModel extends _$AccountsViewModel {
  @override
  FutureOr<UserProfile?> build() async {
    final repository = ref.read(accountsRepositoryProvider);
    return repository.getProfile();
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(accountsRepositoryProvider).getProfile());
  }
}
