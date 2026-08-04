import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logistic_by_strom/features/shipments/data/models/invoice_model.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';

part 'shipment_detail_state.freezed.dart';

@freezed
sealed class ShipmentDetailState with _$ShipmentDetailState {
  const factory ShipmentDetailState({
    required ShipmentRequestModel shipment,
    InvoiceModel? invoice,
    @Default(false) bool isLoadingInvoice,
    @Default(false) bool isInitiatingPayment,
    String? errorMessage,
    PaymentResponseModel? paymentResponse,

  }) = _ShipmentDetailState;
}
