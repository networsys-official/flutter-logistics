import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculator_response.freezed.dart';
part 'calculator_response.g.dart';

@freezed
class CalculatorResponse with _$CalculatorResponse {
  const factory CalculatorResponse({
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'base_shipping_cost') double? baseShippingCost,
    @JsonKey(name: 'customs_duty') double? customsDuty,
    @JsonKey(name: 'vat') double? vat,
    @JsonKey(name: 'delivery_fee') double? deliveryFee,
    String? currency,
  }) = _CalculatorResponse;

  factory CalculatorResponse.fromJson(Map<String, dynamic> json) =>
      _$CalculatorResponseFromJson(json);
}
