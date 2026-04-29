import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/features/auth/providers/auth_provider.dart';
import 'package:logistic_by_strom/features/auth/ui/views/login_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/register_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/otp_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/forgot_password_page.dart';
import 'package:logistic_by_strom/features/auth/ui/views/reset_password_page.dart';
import 'package:logistic_by_strom/features/home/ui/views/home_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/onboarding_page.dart';
import 'package:logistic_by_strom/features/onboarding/ui/views/splash_page.dart';
import 'package:logistic_by_strom/features/accounts/ui/views/account_page.dart';
import 'package:logistic_by_strom/features/shipments/ui/views/shipments_page.dart';
import 'package:logistic_by_strom/shared/widgets/app_shell_scaffold.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authStateNotifier = ValueNotifier<bool>(false);

  ref.listen(authProvider, (_, next) {
    authStateNotifier.value = !authStateNotifier.value;
  });

  return GoRouter(
    initialLocation: AppRoutes.splash,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authStateNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoading = authState.isLoading;
      final isLoggedIn = authState.value?.isLoggedIn ?? false;
      
      final isLoggingIn = state.uri.path == AppRoutes.login || 
                          state.uri.path == AppRoutes.register ||
                          state.uri.path == AppRoutes.otp ||
                          state.uri.path == AppRoutes.forgotPassword ||
                          state.uri.path == AppRoutes.resetPassword;
      final isSplash = state.uri.path == AppRoutes.splash;
      final isOnboarding = state.uri.path == AppRoutes.onboarding;

      if (isLoading) return null;

      if (!isLoggedIn) {
        return isLoggingIn || isOnboarding ? null : AppRoutes.login;
      }

      if (isLoggedIn && (isLoggingIn || isSplash || isOnboarding)) {
        return AppRoutes.home;
      }

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
            identifier: extra['identifier'] as String,
            type: extra['type'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          final email = state.uri.queryParameters['email'] ?? extra['email'] as String? ?? '';
          final token = state.uri.queryParameters['token'] ?? extra['token'] as String? ?? '';
          
          return ResetPasswordPage(
            email: email,
            token: token,
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
