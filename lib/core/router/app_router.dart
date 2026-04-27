import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/features/auth/ui/views/login_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/register_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/otp_page.dart';
import 'package:logistic_by_strom/features/home/ui/views/home_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/onboarding_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/splash_page.dart';
import 'package:logistic_by_strom/features/accounts/ui/views/account_page.dart';
import 'package:logistic_by_strom/features/shipments/ui/views/shipments_page.dart';
import 'package:logistic_by_strom/shared/widgets/app_shell_scaffold.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return OtpPage(
            userId: extra['userId'] as String,
            email: extra['email'] as String?,
            phone: extra['phone'] as String?,
          );
        },
      ),
      
      // Stateful Navigation Shell for preserved tab states
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Shipments Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shipments,
                builder: (context, state) => const ShipmentsPage(),
              ),
            ],
          ),
          // Support Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.support,
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Support Page')),
                ),
              ),
            ],
          ),
          // Account Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const AccountPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
