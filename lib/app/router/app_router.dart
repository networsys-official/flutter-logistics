import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/widgets/app_shell_scaffold.dart';
import 'package:logistic_by_strom/features/auth/ui/views/login_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/register_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/otp_page.dart';
import 'package:logistic_by_strom/features/home/ui/views/home_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/onboarding_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/splash_page.dart';

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
        builder: (context, state) => const OtpPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShellScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const Scaffold(
              body: Center(child: HomePage()),
            ),
          ),
          // GoRoute(
          //   path: AppRoutes.shipments,
          //   builder: (context, state) => const ShipmentsPage(),
          // ),
          // GoRoute(
          //   path: AppRoutes.settings,
          //   builder: (context, state) => const SettingsPage(),
          // ),
        ],
      ),
    ],
  );
}
