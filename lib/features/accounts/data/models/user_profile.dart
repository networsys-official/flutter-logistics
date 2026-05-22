import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';

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

extension UserProfileImageX on UserProfile {
  String? get resolvedImageUrl {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) return null;
    if (profileImageUrl!.startsWith('http')) return profileImageUrl;
    return '${ApiEndpoints.storageBaseUrl}$profileImageUrl';
  }
}
