import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_shipment_model.freezed.dart';
part 'user_shipment_model.g.dart';

enum UserShipmentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('received_at_origin')
  receivedAtOrigin,
  @JsonValue('dispatched')
  dispatched,
  @JsonValue('in_transit')
  inTransit,
  @JsonValue('arrived_at_destination')
  arrivedAtDestination,
  @JsonValue('out_for_delivery')
  outForDelivery,
  @JsonValue('delivered')
  delivered,
  @JsonValue('exception')
  exception,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('returned')
  returned,
}

extension UserShipmentStatusX on UserShipmentStatus {
  String get label {
    switch (this) {
      case UserShipmentStatus.pending:
        return 'Pending';
      case UserShipmentStatus.receivedAtOrigin:
        return 'Received At Origin';
      case UserShipmentStatus.dispatched:
        return 'Dispatched';
      case UserShipmentStatus.inTransit:
        return 'In Transit';
      case UserShipmentStatus.arrivedAtDestination:
        return 'Arrived At Destination';
      case UserShipmentStatus.outForDelivery:
        return 'Out For Delivery';
      case UserShipmentStatus.delivered:
        return 'Delivered';
      case UserShipmentStatus.exception:
        return 'Exception';
      case UserShipmentStatus.cancelled:
        return 'Cancelled';
      case UserShipmentStatus.returned:
        return 'Returned';
    }
  }

  bool get isActive {
    return this != UserShipmentStatus.delivered &&
        this != UserShipmentStatus.cancelled &&
        this != UserShipmentStatus.returned;
  }
}

@freezed
sealed class CountryDetail with _$CountryDetail {
  const factory CountryDetail({
    required int? id,
    required String? name,
  }) = _CountryDetail;

  factory CountryDetail.fromJson(Map<String, dynamic> json) =>
      _$CountryDetailFromJson(json);
}

@freezed
sealed class FacilityDetail with _$FacilityDetail {
  const factory FacilityDetail({
    required int? id,
    required String? name,
  }) = _FacilityDetail;

  factory FacilityDetail.fromJson(Map<String, dynamic> json) =>
      _$FacilityDetailFromJson(json);
}

@freezed
sealed class UserShipmentModel with _$UserShipmentModel {
  const factory UserShipmentModel({
    required int id,
    @JsonKey(name: 'shipment_request_id') int? shipmentRequestId,
    @JsonKey(name: 'tracking_number') required String trackingNumber,
    @JsonKey(name: 'delivery_type') String? deliveryType,
    @JsonKey(name: 'current_status') required UserShipmentStatus currentStatus,
    @JsonKey(name: 'received_at_warehouse') String? receivedAtWarehouse,
    @JsonKey(name: 'dispatched_at') String? dispatchedAt,
    @JsonKey(name: 'arrived_at_destination') String? arrivedAtDestination,
    @JsonKey(name: 'out_for_delivery_at') String? outForDeliveryAt,
    @JsonKey(name: 'delivered_at') String? deliveredAt,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'origin_country') CountryDetail? originCountry,
    @JsonKey(name: 'destination_country') CountryDetail? destinationCountry,
    @JsonKey(name: 'origin_facility') FacilityDetail? originFacility,
    @JsonKey(name: 'destination_facility') FacilityDetail? destinationFacility,
  }) = _UserShipmentModel;

  factory UserShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$UserShipmentModelFromJson(json);
}
