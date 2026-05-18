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
    String? island,
    String? city,
    String? zone,
    @JsonKey(name: 'location_id') int? zoneId,
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') String? addressLine2,
    @JsonKey(name: 'po_box') String? poBox,
    String? label,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);
}
