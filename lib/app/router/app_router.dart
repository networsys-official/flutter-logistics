import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/widgets/app_shell_scaffold.dart';
import 'package:logistic_by_strom/features/onboarding/presentation/views/onboarding_page.dart';
import 'package:logistic_by_strom/features/onboarding/presentation/views/splash_page.dart';
import 'package:logistic_by_strom/features/dashboard/presentation/views/dashboard_page.dart';
import 'package:logistic_by_strom/features/settings/presentation/views/settings_page.dart';
import 'package:logistic_by_strom/features/shipments/presentation/views/shipments_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShellScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.shipments,
            builder: (context, state) => const ShipmentsPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
