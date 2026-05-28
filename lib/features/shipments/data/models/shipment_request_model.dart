import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/utils/num_parser.dart';
import 'invoice_model.dart';

part 'shipment_request_model.freezed.dart';
part 'shipment_request_model.g.dart';

@freezed
sealed class ShipmentRequestModel with _$ShipmentRequestModel {
  const factory ShipmentRequestModel({
    required int id,
    @JsonKey(name: 'request_number') required String requestNumber,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'supplier_tracking_number') String? supplierTrackingNumber,
    @JsonKey(name: 'booking_status') required String bookingStatus,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'delivery_type') required String deliveryType,
    @JsonKey(name: 'service_type') String? serviceType,
    @JsonKey(name: 'requested_at') required String requestedAt,
    @JsonKey(name: 'expected_arrival_at_warehouse') String? expectedArrival,
    @JsonKey(name: 'currency_code') String? currencyCode,
    @JsonKey(name: 'service_rate_per_lb', fromJson: NumParser.doubleFromJson) double? ratePerLb,
    @JsonKey(name: 'special_instructions') String? note,
    @JsonKey(name: 'standby_message') String? standbyMessage,
    List<ShipmentRequestItemModel>? items,
    List<ShipmentDocumentModel>? documents,
    InvoiceModel? invoice,
  }) = _ShipmentRequestModel;

  factory ShipmentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentRequestModelFromJson(json);
}

@freezed
sealed class ShipmentRequestItemModel with _$ShipmentRequestItemModel {
  const factory ShipmentRequestItemModel({
    required int id,
    @JsonKey(name: 'commodity_type') String? commodityType,
    @JsonKey(fromJson: NumParser.intFromJson) @Default(1) int quantity,
    @JsonKey(fromJson: NumParser.doubleFromJson) required double price,
    String? description,
  }) = _ShipmentRequestItemModel;

  factory ShipmentRequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentRequestItemModelFromJson(json);
}

@freezed
sealed class ShipmentDocumentModel with _$ShipmentDocumentModel {
  const factory ShipmentDocumentModel({
    required int id,
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'mime_type') String? mimeType,
  }) = _ShipmentDocumentModel;

  factory ShipmentDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDocumentModelFromJson(json);
}

extension ShipmentDocumentModelX on ShipmentDocumentModel {
  String? get resolvedFileUrl {
    if (fileUrl == null || fileUrl!.isEmpty) return null;
    if (fileUrl!.startsWith('http')) return fileUrl;
    return '${ApiEndpoints.storageBaseUrl}$fileUrl';
  }
}
