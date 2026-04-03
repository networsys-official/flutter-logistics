import 'package:logistic_by_strom/features/shipments/domain/models/shipment.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.activeShipments,
    required this.delayedShipments,
    required this.completedToday,
    required this.onTimeRate,
    required this.bannerTitle,
    required this.bannerMessage,
    required this.highlightedShipments,
  });

  final int activeShipments;
  final int delayedShipments;
  final int completedToday;
  final int onTimeRate;
  final String bannerTitle;
  final String bannerMessage;
  final List<Shipment> highlightedShipments;
}
