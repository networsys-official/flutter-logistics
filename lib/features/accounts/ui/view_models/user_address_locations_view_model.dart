import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/user_address_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_address_locations_view_model.g.dart';

@riverpod
class UserAddressLocations extends _$UserAddressLocations {
  @override
  FutureOr<List<Map<String, dynamic>>> build() async {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.value?.isLoggedIn ?? false;
    
    if (!isLoggedIn) {
      return const [];
    }

    final repository = ref.read(userAddressRepositoryProvider);
    final result = await repository.getLocations();

    return result.fold((failure) => throw failure, (locations) => locations);
  }
}
