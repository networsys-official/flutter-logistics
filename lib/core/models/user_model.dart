import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'phone') required String phone,
    @Default([]) List<String> role,
    @Default([]) List<String> permissions,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Checks if the user has a specific permission.
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  /// Checks if the user has a specific role.
  bool hasRole(String targetRole) {
    return role.contains(targetRole);
  }

  bool hasAllPermissions(List<String> required) =>
      required.every((p) => permissions.contains(p));

  /// Checks if the user has any of the given permissions.
  bool hasAnyPermission(List<String> requiredPermissions) {
    return permissions.any((p) => requiredPermissions.contains(p));
  }
}
