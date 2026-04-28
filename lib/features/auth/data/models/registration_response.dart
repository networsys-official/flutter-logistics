import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_response.freezed.dart';
part 'registration_response.g.dart';

Object? _readUserId(Map json, String key) {
  final data = json['data'];
  if (data is Map) {
    final nestedUserId = data['user_id'];
    if (nestedUserId != null) {
      return nestedUserId.toString();
    }
  }

  final directUserId = json['user_id'];
  return directUserId?.toString() ?? '';
}

Object? _readMessage(Map json, String key) {
  final data = json['data'];
  if (data is Map) {
    final nestedMessage = data['message'];
    if (nestedMessage is String && nestedMessage.isNotEmpty) {
      return nestedMessage;
    }
  }

  final directMessage = json['message'];
  if (directMessage is String && directMessage.isNotEmpty) {
    return directMessage;
  }

  return null;
}

@freezed
sealed class RegistrationResponse with _$RegistrationResponse {
  const factory RegistrationResponse({
    @JsonKey(readValue: _readUserId) required String userId,
    @JsonKey(readValue: _readMessage) String? message,
    @Default(true) bool otpRequired,
  }) = _RegistrationResponse;

  const RegistrationResponse._();

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);
}
