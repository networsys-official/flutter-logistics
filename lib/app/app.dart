import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:logistic_by_strom/app/router/app_router.dart';
import 'package:logistic_by_strom/app/theme/app_theme.dart';
import 'package:logistic_by_strom/core/repositories/logistics_repository.dart';
import 'package:logistic_by_strom/core/repositories/settings_repository.dart';
import 'package:logistic_by_strom/core/services/mock_logistics_service.dart';
import 'package:logistic_by_strom/core/services/mock_settings_service.dart';
import 'package:logistic_by_strom/features/dashboard/presentation/view_models/dashboard_view_model.dart';
import 'package:logistic_by_strom/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:logistic_by_strom/features/shipments/presentation/view_models/shipments_view_model.dart';

class LogisticApp extends StatelessWidget {
  const LogisticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => MockLogisticsService()),
        Provider(
          create: (context) => LogisticsRepository(
            service: context.read<MockLogisticsService>(),
          ),
        ),
        Provider(create: (_) => MockSettingsService()),
        Provider(
          create: (context) =>
              SettingsRepository(service: context.read<MockSettingsService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardViewModel(
            logisticsRepository: context.read<LogisticsRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShipmentsViewModel(
            logisticsRepository: context.read<LogisticsRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(
            settingsRepository: context.read<SettingsRepository>(),
          )..load(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Logistic by Strom',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
