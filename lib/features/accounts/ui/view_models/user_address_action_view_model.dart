import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/user_address_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_address_action_view_model.g.dart';

@riverpod
class UserAddressAction extends _$UserAddressAction {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> addAddress(UserAddress address) async {
    state = const AsyncValue.loading();
    final result = await ref.read(userAddressRepositoryProvider).createAddress(address);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (newAddress) {
        // Update the list state
        ref.read(userAddressViewModelProvider.notifier).fetchAddresses();
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> updateAddress(UserAddress address) async {
    state = const AsyncValue.loading();
    final result = await ref.read(userAddressRepositoryProvider).updateAddress(address);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedAddress) {
        // Update the list state
        ref.read(userAddressViewModelProvider.notifier).fetchAddresses();
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}
