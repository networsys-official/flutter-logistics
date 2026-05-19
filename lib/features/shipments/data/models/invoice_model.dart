import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:logistic_by_strom/core/utils/num_parser.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
sealed class InvoiceModel with _$InvoiceModel {
  const factory InvoiceModel({
    required int id,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(fromJson: NumParser.doubleFromJson) required double subtotal,
    @JsonKey(name: 'tax_amount', fromJson: NumParser.doubleFromJson) required double taxAmount,
    @JsonKey(name: 'discount_amount', fromJson: NumParser.doubleFromJson) required double discountAmount,
    @JsonKey(name: 'total_amount', fromJson: NumParser.doubleFromJson) required double totalAmount,
    required String status,
    @JsonKey(name: 'issued_at') required String issuedAt,
    @JsonKey(name: 'due_at') required String dueAt,
    @JsonKey(name: 'paid_at') String? paidAt,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}

@freezed
sealed class PaymentResponseModel with _$PaymentResponseModel {
  const factory PaymentResponseModel({
    required bool success,
    required String message,
    required PaymentData data,
  }) = _PaymentResponseModel;

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseModelFromJson(json);
}

@freezed
sealed class PaymentData with _$PaymentData {
  const factory PaymentData({
    @JsonKey(name: 'payment_reference') required String paymentReference,
    required String gateway,
    @JsonKey(name: 'checkout_url') required String checkoutUrl,
  }) = _PaymentData;

  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);
}

