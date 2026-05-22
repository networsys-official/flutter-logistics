import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/core/models/user_address.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/user_address_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_address_repository.g.dart';

@riverpod
UserAddressRepository userAddressRepository(Ref ref) {
  return UserAddressRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(storageServiceProvider.notifier),
  );
}

abstract interface class UserAddressRepository {
  ResultFuture<List<UserAddress>> getAddresses();
  ResultFuture<UserAddress> createAddress(UserAddress address);
  ResultFuture<UserAddress> updateAddress(UserAddress address);
  ResultFuture<void> deleteAddress(int id);
  ResultFuture<List<Map<String, dynamic>>> getLocations();
}
