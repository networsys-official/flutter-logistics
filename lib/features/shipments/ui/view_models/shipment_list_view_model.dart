import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

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

    return switch (result) {
      Left(value: final failure) => throw failure.message,
      Right(value: final shipments) => ShipmentListGroups(
        all: shipments,
        booked: _filterByStatus(shipments, 'booked'),
        pending: _filterByStatus(shipments, 'pending'),
        invoiced: _filterByStatus(shipments, 'invoiced'),
        standby: _filterByStatus(shipments, 'standby'),
        cancelled: _filterByStatus(shipments, 'cancelled'),
      ),
    };
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _fetchShipments());
  }

  List<ShipmentRequestModel> _filterByStatus(
    List<ShipmentRequestModel> shipments,
    String status,
  ) {
    return shipments
        .where((shipment) => shipment.bookingStatus == status)
        .toList();
  }
}
