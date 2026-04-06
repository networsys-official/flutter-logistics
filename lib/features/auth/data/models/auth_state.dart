import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'photo_url') String? photoUrl,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({AuthUser? user, String? token}) = _AuthState;

  const AuthState._();

  bool get isLoggedIn => user != null && token != null;
}
