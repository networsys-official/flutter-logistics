import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_address.freezed.dart';
part 'user_address.g.dart';

enum AddressType {
  @JsonValue('home')
  home,
  @JsonValue('office')
  office,
  @JsonValue('warehouse')
  warehouse,
  @JsonValue('other')
  other,
}

@freezed
abstract class UserAddress with _$UserAddress {
  const factory UserAddress({
    required int id,
    @JsonKey(name: 'user_id') String? userId,
    AddressType? type,
    @JsonKey(name: 'contact_name') String? contactName,
    String? phone,
    @JsonKey(name: 'country_id') required int countryId,
    @JsonKey(name: 'country_name') String? countryName,
    @JsonKey(name: 'location_id') int? locationId,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') String? addressLine2,
    @JsonKey(name: 'postal_code') String? postalCode,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);
}
