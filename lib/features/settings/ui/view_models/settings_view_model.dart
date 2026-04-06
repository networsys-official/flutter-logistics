import 'package:flutter/foundation.dart';

import 'package:logistic_by_strom/features/settings/data/repositories/settings_repository.dart';
import 'package:logistic_by_strom/features/settings/data/models/app_settings.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  AppSettings? _settings;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  AppSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _settings = await _settingsRepository.getSettings();
    } catch (_) {
      _errorMessage = 'Unable to load settings.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _persist(_settings!.copyWith(notificationsEnabled: value));
  }

  Future<void> setSyncOnCellular(bool value) async {
    await _persist(_settings!.copyWith(syncOnCellular: value));
  }

  Future<void> setBiometricLockEnabled(bool value) async {
    await _persist(_settings!.copyWith(biometricLockEnabled: value));
  }

  Future<void> _persist(AppSettings updatedSettings) async {
    _isSaving = true;
    _errorMessage = null;
    _settings = updatedSettings;
    notifyListeners();

    try {
      _settings = await _settingsRepository.saveSettings(updatedSettings);
    } catch (_) {
      _errorMessage = 'Unable to save settings.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
