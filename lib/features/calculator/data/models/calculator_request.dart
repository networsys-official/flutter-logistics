import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculator_request.freezed.dart';
part 'calculator_request.g.dart';

@freezed
class CalculatorRequest with _$CalculatorRequest {
  const factory CalculatorRequest({
    @JsonKey(name: 'shipping_type') required String shippingType,
    @JsonKey(name: 'tariff_code') int? tariffCode,
    @JsonKey(name: 'estimated_weight_lbs') required double estimatedWeightLbs,
    @JsonKey(name: 'length_cm') required double lengthCm,
    @JsonKey(name: 'width_cm') required double widthCm,
    @JsonKey(name: 'height_cm') required double heightCm,
    @JsonKey(name: 'price') required double price,
  }) = _CalculatorRequest;

  factory CalculatorRequest.fromJson(Map<String, dynamic> json) =>
      _$CalculatorRequestFromJson(json);
}
