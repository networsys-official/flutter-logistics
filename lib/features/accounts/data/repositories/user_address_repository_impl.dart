import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/app_failure.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/user_address_repository.dart';

class UserAddressRepositoryImpl implements UserAddressRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  UserAddressRepositoryImpl(this._apiClient, this._storageService);

  @override
  ResultFuture<List<UserAddress>> getAddresses() async {
    try {

      final token = await _storageService.getToken();
      final response = await _apiClient.get(
        ApiEndpoints.userAddresses,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      final List data = response.data['data'];
      final addresses = data.map((e) => UserAddress.fromJson(e)).toList();

      return Right(addresses);
    } catch (e) {

      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserAddress> createAddress(UserAddress address) async {
    try {
      final token = await _storageService.getToken();
      final response = await _apiClient.post(
        ApiEndpoints.userAddresses,
        data: address.toJson(),
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return Right(UserAddress.fromJson(response.data['data']));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserAddress> updateAddress(UserAddress address) async {
    try {
      final token = await _storageService.getToken();
      final response = await _apiClient.put(
        '${ApiEndpoints.userAddresses}/${address.id}',
        data: address.toJson(),
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return Right(UserAddress.fromJson(response.data['data']));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> deleteAddress(int id) async {
    try {
      final token = await _storageService.getToken();
      await _apiClient.delete(
        '${ApiEndpoints.userAddresses}/$id',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<Map<String, dynamic>>> getLocations() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.userAddressesLocations,
      );
      final List data = response.data['data'];
      return Right(data.cast<Map<String, dynamic>>());
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
