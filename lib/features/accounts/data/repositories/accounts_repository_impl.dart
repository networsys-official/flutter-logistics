import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/app_failure.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/accounts_repository.dart';
class AccountsRepositoryImpl implements AccountsRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AccountsRepositoryImpl(this._apiClient, this._storageService);

  @override
  ResultFuture<UserProfile> getProfile() async {
    try {
      final token = await _storageService.getToken();
      final response = await _apiClient.get(
        ApiEndpoints.showProfile,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return Right(UserProfile.fromJson(response.data['data']));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? gender,
    String? dob,
    String? language,
    String? imagePath,
  }) async {
    try {
      final token = await _storageService.getToken();
      final formData = FormData.fromMap({
        'name': name,
        'phone': phone,
        'gender': ?gender,
        'date_of_birth': ?dob,
        'preferred_language': ?language,
        '_method': 'PUT',
        if (imagePath != null)
          'avatar': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
      });

      final response = await _apiClient.post(
        ApiEndpoints.updateProfile,
        data: formData,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      return Right(UserProfile.fromJson(response.data['data']));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final token = await _storageService.getToken();
      await _apiClient.put(
        ApiEndpoints.updatePassword,
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
