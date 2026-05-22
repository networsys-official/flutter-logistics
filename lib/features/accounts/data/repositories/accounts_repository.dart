import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_repository.g.dart';

@riverpod
AccountsRepository accountsRepository(Ref ref) {
  return AccountsRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(storageServiceProvider.notifier),
  );
}

abstract interface class AccountsRepository {
  ResultFuture<UserProfile> getProfile();

  ResultFuture<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? gender,
    String? dob,
    String? language,
    String? imagePath,
  });

  ResultVoid updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
