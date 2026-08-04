import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'package:logistic_by_strom/core/router/app_router.dart';
import 'package:logistic_by_strom/core/theme/app_theme.dart';

import 'core/services/deep_link_service.dart';

class LogisticApp extends ConsumerStatefulWidget {
  const LogisticApp({super.key});

  @override
  ConsumerState<LogisticApp> createState() => _LogisticAppState();
}

class _LogisticAppState extends ConsumerState<LogisticApp> {
  late final DeepLinkService _deepLinkService;

  @override
  void initState() {
    super.initState();

    final router = ref.read(appRouterProvider);

    _deepLinkService = DeepLinkService(router);

    Future.microtask(() async {
      await _deepLinkService.init();
    });
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
