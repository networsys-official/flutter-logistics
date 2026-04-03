import 'package:logistic_by_strom/features/settings/domain/models/app_settings.dart';

class MockSettingsService {
  AppSettings _settings = const AppSettings(
    notificationsEnabled: true,
    syncOnCellular: false,
    biometricLockEnabled: true,
  );

  Future<AppSettings> fetchSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _settings;
  }

  Future<AppSettings> saveSettings(AppSettings settings) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _settings = settings;
    return _settings;
  }
}
