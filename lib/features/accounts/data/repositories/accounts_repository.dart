import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';

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
}
