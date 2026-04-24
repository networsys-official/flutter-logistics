import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

Object? _readId(Map json, String key) {
  final val = json['id'] ?? json['user_id'] ?? json['customer_id'] ?? json['uuid'];
  return val?.toString() ?? '';
}

Object? _readName(Map json, String key) {
  final val = json['name'] ?? json['full_name'] ?? json['username'] ?? json['first_name'];
  return val?.toString() ?? '';
}

Object? _readEmail(Map json, String key) {
  final val = json['email'] ?? json['email_address'];
  return val?.toString() ?? '';
}

Object? _readPhoto(Map json, String key) {
  final val = json['photo_url'] ?? json['photoUrl'] ?? json['avatar'];
  return val is String && val.isNotEmpty ? val : null;
}

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    @JsonKey(readValue: _readId) required String id,
    @JsonKey(readValue: _readName) required String name,
    @JsonKey(readValue: _readEmail) required String email,
    @JsonKey(readValue: _readPhoto, name: 'photo_url') String? photoUrl,
  }) = _AuthUser;

  const AuthUser._();

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  static AuthUser? fromResponse(Map<String, dynamic> data) {
    final rawUser = data['user'] ??
        _asMap(data['data'])['user'] ??
        _asMap(data['data'])['customer'] ??
        data['customer'];

    final userMap = _asMap(rawUser);
    if (userMap.isNotEmpty) {
      return AuthUser.fromJson(userMap);
    }

    if (data['id'] != null || data['name'] != null || data['email'] != null) {
      return AuthUser.fromJson(data);
    }

    final nestedData = _asMap(data['data']);
    if (nestedData['id'] != null ||
        nestedData['name'] != null ||
        nestedData['email'] != null) {
      return AuthUser.fromJson(nestedData);
    }

    return null;
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return const <String, dynamic>{};
  }
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({AuthUser? user, String? token}) = _AuthState;

  const AuthState._();

  bool get isLoggedIn => user != null && token != null;
}
