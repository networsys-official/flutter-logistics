import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_shipment_request.freezed.dart';
part 'add_shipment_request.g.dart';

@freezed
abstract class AddShipmentRequest with _$AddShipmentRequest {
  const factory AddShipmentRequest({
    @JsonKey(name: 'origin_country_id') required int originCountryId,
    @JsonKey(name: 'origin_facility_id') required int originFacilityId,
    @JsonKey(name: 'destination_country_id') required int destinationCountryId,
    @JsonKey(name: 'destination_facility_id')
    required int destinationFacilityId,
    @JsonKey(name: 'service_type_id') required int serviceTypeId,
    @JsonKey(name: 'delivery_type') required String deliveryType,
    @JsonKey(name: 'destination_location_id') int? locationId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'supplier_tracking_number') required String trackingNumber,
    @JsonKey(name: 'expected_arrival_at_warehouse')
    required String expectedArrival,
    @JsonKey(name: 'special_instructions') String? note,
    @JsonKey(name: 'items') required List<ShipmentItemRequest> items,
  }) = _AddShipmentRequest;

  factory AddShipmentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddShipmentRequestFromJson(json);
}

@freezed
abstract class ShipmentItemRequest with _$ShipmentItemRequest {
  const factory ShipmentItemRequest({
    @JsonKey(name: 'commodity_type') String? commodityType,
    @JsonKey(name: 'price') required double price,
  }) = _ShipmentItemRequest;

  factory ShipmentItemRequest.fromJson(Map<String, dynamic> json) =>
      _$ShipmentItemRequestFromJson(json);
}
