import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

@riverpod
class StorageService extends _$StorageService {
  late final FlutterSecureStorage _storage;

  @override
  void build() {
    _storage = const FlutterSecureStorage();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> saveUser(String userJson) async {
    await _storage.write(key: 'auth_user', value: userJson);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: 'auth_user');
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: 'auth_user');
  }
}
