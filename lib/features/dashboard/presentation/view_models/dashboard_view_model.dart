import 'package:flutter/foundation.dart';

import 'package:logistic_by_strom/core/models/dashboard_snapshot.dart';
import 'package:logistic_by_strom/core/repositories/logistics_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({required LogisticsRepository logisticsRepository})
    : _logisticsRepository = logisticsRepository;

  final LogisticsRepository _logisticsRepository;

  DashboardSnapshot? _snapshot;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;

  DashboardSnapshot? get snapshot => _snapshot;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      _snapshot = await _logisticsRepository.getDashboardSnapshot(
        forceRefresh: refresh,
      );
    } catch (_) {
      _errorMessage = 'Unable to load dashboard data.';
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }
}
