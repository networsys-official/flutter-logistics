import 'package:flutter/material.dart';

import 'package:logistic_by_strom/app/router/app_router.dart';
import 'package:logistic_by_strom/app/theme/app_theme.dart';

class LogisticApp extends StatelessWidget {
  const LogisticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Logistic by Strom',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
