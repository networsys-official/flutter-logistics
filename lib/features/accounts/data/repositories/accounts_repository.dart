import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';

class AccountsRepository {
  AccountsRepository();

  Future<UserProfile> getProfile() async {
    // Simulated API call or fetching from local cache
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const UserProfile(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 234 567 8900',
      address: '123 Main St, Springfield, IL',
      profileImageUrl: '',
    );
  }
}
