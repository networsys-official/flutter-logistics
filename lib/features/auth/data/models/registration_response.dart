import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:logistic_by_strom/features/auth/data/models/auth_state.dart';

part 'registration_response.freezed.dart';
part 'registration_response.g.dart';

@freezed
abstract class RegistrationResponse with _$RegistrationResponse {
  const factory RegistrationResponse({
    required AuthUser user,
    String? message,
    @Default(true) bool otpRequired,
  }) = _RegistrationResponse;

  const RegistrationResponse._();

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);
}
