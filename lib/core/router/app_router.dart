import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/features/auth/providers/auth_provider.dart';
import 'package:logistic_by_strom/features/auth/ui/views/login_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/register_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/otp_page.dart';
import 'package:logistic_by_strom/features/home/ui/views/home_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/onboarding_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/splash_page.dart';
import 'package:logistic_by_strom/features/accounts/ui/views/account_page.dart';
import 'package:logistic_by_strom/features/shipments/ui/views/shipments_page.dart';
import 'package:logistic_by_strom/shared/widgets/app_shell_scaffold.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: AppRoutes.splash,
    navigatorKey: rootNavigatorKey,
    // Redirect logic based on Auth State
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isLoggedIn = authState.value?.isLoggedIn ?? false;
      
      final isLoggingIn = state.uri.path == AppRoutes.login || 
                          state.uri.path == AppRoutes.register ||
                          state.uri.path == AppRoutes.otp;
      final isSplash = state.uri.path == AppRoutes.splash;
      final isOnboarding = state.uri.path == AppRoutes.onboarding;

      if (isLoading || isSplash) return null;

      if (!isLoggedIn) {
        // If not logged in and not on an auth page, go to login
        return isLoggingIn || isOnboarding ? null : AppRoutes.login;
      }

      // If logged in and trying to go to login, go home
      if (isLoggedIn && isLoggingIn) return AppRoutes.home;

      return null;
    },
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shipments,
                builder: (context, state) => const ShipmentsPage(),
              ),
            ],
          ),
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
