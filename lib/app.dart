import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class LogisticApp extends StatelessWidget {
  const LogisticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}

