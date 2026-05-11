import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';

abstract interface class UserAddressRepository {
  ResultFuture<List<UserAddress>> getAddresses();
  ResultFuture<UserAddress> createAddress(UserAddress address);
  ResultFuture<UserAddress> updateAddress(UserAddress address);
  ResultFuture<void> deleteAddress(int id);
}
