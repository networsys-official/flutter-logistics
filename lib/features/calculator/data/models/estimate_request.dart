import 'package:freezed_annotation/freezed_annotation.dart';

part 'estimate_request.freezed.dart';
part 'estimate_request.g.dart';

@freezed
sealed class EstimateRequest with _$EstimateRequest {
  const factory EstimateRequest({
    @JsonKey(name: 'shipping_type') required String shippingType,
    @JsonKey(name: 'delivery_type') required String deliveryType,
    @JsonKey(name: 'destination_location_id') int? destinationLocationId,
    @JsonKey(name: 'tariff_code') int? tariffCode,
    @JsonKey(name: 'estimated_weight_lbs') required double estimatedWeightLbs,
    @JsonKey(name: 'length_cm') required double lengthCm,
    @JsonKey(name: 'width_cm') required double widthCm,
    @JsonKey(name: 'height_cm') required double heightCm,
    @JsonKey(name: 'price') required double price,
  }) = _EstimateRequest;

  factory EstimateRequest.fromJson(Map<String, dynamic> json) =>
      _$EstimateRequestFromJson(json);
}
