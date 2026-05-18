import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shipment_list_view_model.g.dart';

class ShipmentListGroups {
  const ShipmentListGroups({
    required this.all,
    required this.booked,
    required this.pending,
    required this.invoiced,
    required this.standby,
    required this.cancelled,
  });

  final List<ShipmentRequestModel> all;
  final List<ShipmentRequestModel> booked;
  final List<ShipmentRequestModel> pending;
  final List<ShipmentRequestModel> invoiced;
  final List<ShipmentRequestModel> standby;
  final List<ShipmentRequestModel> cancelled;

  int get totalCount => all.length;
  int get activeCount => pending.length + invoiced.length + booked.length;
  int get needsAttentionCount => standby.length;
  bool get isEmpty => all.isEmpty;
}

@riverpod
class ShipmentListViewModel extends _$ShipmentListViewModel {
  @override
  Future<ShipmentListGroups> build() async {
    return _fetchShipments();
  }

  Future<ShipmentListGroups> _fetchShipments() async {
    final repository = ref.read(shipmentRepositoryProvider);
    final result = await repository.getShipmentRequests();

    return result.fold(
      (failure) => throw failure.message,
      (shipments) => ShipmentListGroups(
        all: shipments,
        booked: _booked(shipments),
        pending: _pending(shipments),
        invoiced: _invoiced(shipments),
        standby: _standby(shipments),
        cancelled: _cancelled(shipments),
      ),
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _fetchShipments());
  }

  List<ShipmentRequestModel> _invoiced(List<ShipmentRequestModel> shipments) =>
      shipments
          .where((shipment) => shipment.bookingStatus == 'invoiced')
          .toList();

  List<ShipmentRequestModel> _pending(List<ShipmentRequestModel> shipments) =>
      shipments
          .where((shipment) => shipment.bookingStatus == 'pending')
          .toList();

  List<ShipmentRequestModel> _standby(List<ShipmentRequestModel> shipments) =>
      shipments
          .where((shipment) => shipment.bookingStatus == 'standby')
          .toList();

  List<ShipmentRequestModel> _cancelled(List<ShipmentRequestModel> shipments) =>
      shipments
          .where((shipment) => shipment.bookingStatus == 'cancelled')
          .toList();

  List<ShipmentRequestModel> _booked(List<ShipmentRequestModel> shipments) =>
      shipments
          .where((shipment) => shipment.bookingStatus == 'booked')
          .toList();
}
