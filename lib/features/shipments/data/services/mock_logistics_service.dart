import 'package:logistic_by_strom/features/shipments/domain/models/shipment.dart';

class MockLogisticsService {
  Future<List<Shipment>> fetchShipments() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    return const [
      Shipment(
        id: 'ST-2048',
        clientName: 'Bahamas Retail Group',
        routeLabel: 'Nassau Port -> Marsh Harbour',
        priorityLabel: 'Priority',
        etaLabel: 'Arrives in 2h',
        status: ShipmentStatus.inTransit,
        progress: 0.72,
      ),
      Shipment(
        id: 'ST-2051',
        clientName: 'Cable Beach Resorts',
        routeLabel: 'Freeport Hub -> Nassau',
        priorityLabel: 'Standard',
        etaLabel: 'Ready for dispatch',
        status: ShipmentStatus.readyForDispatch,
        progress: 0.35,
      ),
      Shipment(
        id: 'ST-2056',
        clientName: 'Andros Fresh Supply',
        routeLabel: 'Nassau -> North Andros',
        priorityLabel: 'Priority',
        etaLabel: 'Delayed by weather',
        status: ShipmentStatus.delayed,
        progress: 0.64,
      ),
      Shipment(
        id: 'ST-2058',
        clientName: 'Harbour Construction',
        routeLabel: 'Warehouse 4 -> Paradise Island',
        priorityLabel: 'Express',
        etaLabel: 'Scheduled for 16:30',
        status: ShipmentStatus.scheduled,
        progress: 0.12,
      ),
      Shipment(
        id: 'ST-2060',
        clientName: 'Palm Cay Market',
        routeLabel: 'Inbound Cargo -> East Bay',
        priorityLabel: 'Standard',
        etaLabel: 'Delivered 40m ago',
        status: ShipmentStatus.delivered,
        progress: 1,
      ),
    ];
  }
}
