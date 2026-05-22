import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/shipment_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shipment_detail_view_model.g.dart';

@riverpod
class ShipmentDetailViewModel extends _$ShipmentDetailViewModel {
  @override
  ShipmentDetailState build(ShipmentRequestModel shipment) {
    return ShipmentDetailState(
      shipment: shipment,
      invoice: shipment.invoice,
    );
  }

  Future<void> fetchInvoice() async {
    state = state.copyWith(isLoadingInvoice: true, errorMessage: null);

    final result = await ref
        .read(shipmentRepositoryProvider)
        .getInvoice(state.shipment.id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingInvoice: false,
        errorMessage: failure.message,
      ),
      (invoice) => state = state.copyWith(
        isLoadingInvoice: false,
        invoice: invoice,
      ),
    );
  }

  Future<void> initiatePayment(String gateway) async {
    final invoice = state.invoice;
    if (invoice == null) return;

    state = state.copyWith(isInitiatingPayment: true, errorMessage: null);

    final result = await ref
        .read(shipmentRepositoryProvider)
        .initiatePayment(invoice.id, gateway);

    result.fold(
      (failure) => state = state.copyWith(
        isInitiatingPayment: false,
        errorMessage: failure.message,
      ),
      (response) => state = state.copyWith(
        isInitiatingPayment: false,
        paymentResponse: response,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
