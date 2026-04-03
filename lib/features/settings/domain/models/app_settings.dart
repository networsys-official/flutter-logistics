class AppSettings {
  const AppSettings({
    required this.notificationsEnabled,
    required this.syncOnCellular,
    required this.biometricLockEnabled,
  });

  final bool notificationsEnabled;
  final bool syncOnCellular;
  final bool biometricLockEnabled;

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? syncOnCellular,
    bool? biometricLockEnabled,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      syncOnCellular: syncOnCellular ?? this.syncOnCellular,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
    );
  }
}
