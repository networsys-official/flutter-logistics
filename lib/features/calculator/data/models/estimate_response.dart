import 'package:freezed_annotation/freezed_annotation.dart';

part 'estimate_response.freezed.dart';
part 'estimate_response.g.dart';

@freezed
sealed class EstimateResponse with _$EstimateResponse {
  const factory EstimateResponse({
    @JsonKey(name: 'estimated_price') required double estimatedPrice,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'breakdown') required EstimateBreakdown breakdown,
  }) = _EstimateResponse;

  factory EstimateResponse.fromJson(Map<String, dynamic> json) =>
      _$EstimateResponseFromJson(json);
}

@freezed
sealed class EstimateBreakdown with _$EstimateBreakdown {
  const factory EstimateBreakdown({
    @JsonKey(name: 'shipping_price') required double shippingPrice,
    @JsonKey(name: 'delivery_surcharge') required double deliverySurcharge,
    @JsonKey(name: 'customs_duty') required double customsDuty,
    @JsonKey(name: 'processing_fee') required double processingFee,
    @JsonKey(name: 'document_fee') required double documentFee,
    @JsonKey(name: 'vat') required double vat,
  }) = _EstimateBreakdown;

  factory EstimateBreakdown.fromJson(Map<String, dynamic> json) =>
      _$EstimateBreakdownFromJson(json);
}
