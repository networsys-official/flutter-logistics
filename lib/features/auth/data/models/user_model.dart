import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

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
sealed class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(readValue: _readId) required String id,
    @JsonKey(readValue: _readName) required String name,
    @JsonKey(readValue: _readEmail) required String email,
    @JsonKey(readValue: _readPhoto, name: 'photo_url') String? photoUrl,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
