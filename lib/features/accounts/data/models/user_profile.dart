import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required String id,
    required String name,
    required String email,
    String? phone,
    String? address,
    @JsonKey(name: 'avatar') String? profileImageUrl,
    String? gender,
    @JsonKey(name: 'date_of_birth') String? dob,
    @JsonKey(name: 'preferred_language') String? language,
    @JsonKey(name: 'company_name') String? companyName,
    String? tin,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
