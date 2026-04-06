import 'dart:async';

import 'package:logistic_by_strom/features/home/data/models/dashboard_snapshot.dart';
import 'package:logistic_by_strom/features/shipments/data/services/mock_logistics_service.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment.dart';

class LogisticsRepository {
  LogisticsRepository({required MockLogisticsService service})
    : _service = service;

  final MockLogisticsService _service;

  List<Shipment>? _cachedShipments;
  Future<List<Shipment>>? _inFlightRequest;

  Future<List<Shipment>> getShipments({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedShipments != null) {
      return _cachedShipments!;
    }

    if (!forceRefresh && _inFlightRequest != null) {
      return _inFlightRequest!;
    }

    final request = _service.fetchShipments().then((shipments) {
      _cachedShipments = List<Shipment>.unmodifiable(shipments);
      return _cachedShipments!;
    });

    _inFlightRequest = request;

    try {
      return await request;
    } finally {
      _inFlightRequest = null;
    }
  }

  Future<DashboardSnapshot> getDashboardSnapshot({
    bool forceRefresh = false,
  }) async {
    final shipments = await getShipments(forceRefresh: forceRefresh);

    final int delayedShipments = shipments
        .where((item) => item.isDelayed)
        .length;
    final int completedToday = shipments
        .where((item) => item.isCompleted)
        .length;
    final int activeShipments = shipments
        .where((item) => !item.isCompleted)
        .length;
    final int onTimeShipments = shipments
        .where((item) => !item.isDelayed)
        .length;
    final int onTimeRate = ((onTimeShipments / shipments.length) * 100).round();

    final List<Shipment> highlightedShipments = shipments
        .where((item) => !item.isCompleted)
        .take(3)
        .toList(growable: false);

    final String bannerTitle = delayedShipments == 0
        ? 'Operations are on pace'
        : 'Attention needed on delayed routes';
    final String bannerMessage = delayedShipments == 0
        ? 'All active deliveries are moving inside today\'s expected windows.'
        : '$delayedShipments route needs intervention before the next dispatch cut-off.';

    return DashboardSnapshot(
      activeShipments: activeShipments,
      delayedShipments: delayedShipments,
      completedToday: completedToday,
      onTimeRate: onTimeRate,
      bannerTitle: bannerTitle,
      bannerMessage: bannerMessage,
      highlightedShipments: highlightedShipments,
    );
  }
}
