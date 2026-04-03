import 'package:logistic_by_strom/core/models/app_settings.dart';
import 'package:logistic_by_strom/core/services/mock_settings_service.dart';

class SettingsRepository {
  SettingsRepository({required MockSettingsService service})
    : _service = service;

  final MockSettingsService _service;

  AppSettings? _cachedSettings;

  Future<AppSettings> getSettings({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedSettings != null) {
      return _cachedSettings!;
    }

    _cachedSettings = await _service.fetchSettings();
    return _cachedSettings!;
  }

  Future<AppSettings> saveSettings(AppSettings settings) async {
    _cachedSettings = await _service.saveSettings(settings);
    return _cachedSettings!;
  }
}
