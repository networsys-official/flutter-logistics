import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'package:logistic_by_strom/core/router/app_router.dart';
import 'package:logistic_by_strom/core/theme/app_theme.dart';

class LogisticApp extends ConsumerWidget {
  const LogisticApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
