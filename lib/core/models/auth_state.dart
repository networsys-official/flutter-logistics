import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({UserModel? user, String? token}) = _AuthState;

  const AuthState._();

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  bool get isLoggedIn => user != null && token != null;
}
