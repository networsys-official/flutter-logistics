import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/core/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/user_address_repository.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/user_address_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_address_view_model.g.dart';

@riverpod
UserAddressRepository userAddressRepository(Ref ref) {
  return UserAddressRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(storageServiceProvider.notifier),
  );
}

@riverpod
class UserAddressViewModel extends _$UserAddressViewModel {
  @override
  FutureOr<List<UserAddress>> build() async {
    final repository = ref.read(userAddressRepositoryProvider);
    final result = await repository.getAddresses();

    return result.fold((failure) => throw failure, (addresses) => addresses);
  }

  Future<void> fetchAddresses() async {
    state = const AsyncValue.loading();
    final result = await ref.read(userAddressRepositoryProvider).getAddresses();
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (addresses) => AsyncValue.data(addresses),
    );
  }

  Future<bool> addAddress(UserAddress address) async {
    final result = await ref
        .read(userAddressRepositoryProvider)
        .createAddress(address);
    return result.fold((failure) => false, (newAddress) {
      state.whenData((addresses) {
        state = AsyncValue.data([...addresses, newAddress]);
      });
      return true;
    });
  }

  Future<bool> updateAddress(UserAddress address) async {
    final result = await ref
        .read(userAddressRepositoryProvider)
        .updateAddress(address);
    return result.fold((failure) => false, (updatedAddress) {
      state.whenData((addresses) {
        state = AsyncValue.data(
          addresses
              .map((e) => e.id == updatedAddress.id ? updatedAddress : e)
              .toList(),
        );
      });
      return true;
    });
  }

  Future<bool> deleteAddress(int id) async {
    final result = await ref
        .read(userAddressRepositoryProvider)
        .deleteAddress(id);
    return result.fold((failure) => false, (_) {
      state.whenData((addresses) {
        state = AsyncValue.data(addresses.where((e) => e.id != id).toList());
      });
      return true;
    });
  }
}
