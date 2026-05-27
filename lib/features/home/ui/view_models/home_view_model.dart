import 'package:logistic_by_strom/features/shipments/data/models/user_shipment_model.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'home_view_model.g.dart';

class HomeShipmentsState {
  final UserShipmentModel? currentShipment;
  final List<UserShipmentModel> recentShipments;

  const HomeShipmentsState({
    this.currentShipment,
    required this.recentShipments,
  });
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeShipmentsState> build() async {
    return _fetchHomeShipments();
  }

  Future<HomeShipmentsState> _fetchHomeShipments() async {
    final repository = ref.read(shipmentRepositoryProvider);
    final result = await repository.getMyOrders();

    return switch (result) {
      Left(value: final failure) => throw failure.message,
      Right(value: final shipments) => _mapToHomeState(shipments),
    };
  }

  HomeShipmentsState _mapToHomeState(List<UserShipmentModel> shipments) {
    if (shipments.isEmpty) {
      return const HomeShipmentsState(recentShipments: []);
    }

    // Sort by created_at / ID (normally API returns latest first, but let's be sure)
    final sortedShipments = List<UserShipmentModel>.from(shipments)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Find the latest active shipment
    UserShipmentModel? current;
    final List<UserShipmentModel> recent = [];

    for (var shipment in sortedShipments) {
      if (current == null && shipment.currentStatus.isActive) {
        current = shipment;
      } else {
        recent.add(shipment);
      }
    }

    return HomeShipmentsState(
      currentShipment: current,
      recentShipments: recent,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _fetchHomeShipments());
  }
}
