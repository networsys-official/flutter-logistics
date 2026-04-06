import 'package:flutter/foundation.dart';

import 'package:logistic_by_strom/features/shipments/data/repositories/logistics_repository.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment.dart';

class ShipmentsViewModel extends ChangeNotifier {
  ShipmentsViewModel({required LogisticsRepository logisticsRepository})
    : _logisticsRepository = logisticsRepository;

  final LogisticsRepository _logisticsRepository;

  List<Shipment> _shipments = const [];
  bool _isLoading = false;
  String _query = '';
  String? _errorMessage;

  List<Shipment> get shipments => _shipments;
  bool get isLoading => _isLoading;
  String get query => _query;
  String? get errorMessage => _errorMessage;

  List<Shipment> get visibleShipments {
    if (_query.isEmpty) {
      return _shipments;
    }

    final normalizedQuery = _query.toLowerCase();

    return _shipments
        .where((shipment) {
          return shipment.id.toLowerCase().contains(normalizedQuery) ||
              shipment.clientName.toLowerCase().contains(normalizedQuery) ||
              shipment.routeLabel.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  Future<void> load({bool refresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _shipments = await _logisticsRepository.getShipments(
        forceRefresh: refresh,
      );
    } catch (_) {
      _errorMessage = 'Unable to load shipments.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateQuery(String value) {
    _query = value.trim();
    notifyListeners();
  }
}
