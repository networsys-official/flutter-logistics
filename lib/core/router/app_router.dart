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
import 'package:logistic_by_strom/features/accounts/ui/views/edit_profile_page.dart';
import 'package:logistic_by_strom/features/accounts/ui/views/change_password_page.dart';
import 'package:logistic_by_strom/features/accounts/ui/views/terms_and_conditions_page.dart';
import 'package:logistic_by_strom/features/accounts/ui/views/privacy_policy_page.dart';
import 'package:logistic_by_strom/features/accounts/ui/views/faq_page.dart';
import 'package:logistic_by_strom/features/shipments/ui/views/shipments_page.dart';
import 'package:logistic_by_strom/features/support/ui/views/support_page.dart';
import 'package:logistic_by_strom/features/calculator/ui/views/calculator_page.dart';
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

      final isAuthChecking = authState.isLoading;
      final isUserLoggedIn = authState.value?.isLoggedIn ?? false;
      final currentPath = state.uri.path;

      final authRoutes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.otp,
        AppRoutes.forgotPassword,
        AppRoutes.resetPassword,
      ];

      final publicRoutes = [...authRoutes, AppRoutes.onboarding];

      final guestRestrictedRoutes = [
        ...authRoutes,
        AppRoutes.splash,
        AppRoutes.onboarding,
      ];

      final isPublicRoute = publicRoutes.contains(currentPath);
      final isGuestRestrictedRoute = guestRestrictedRoutes.contains(
        currentPath,
      );

      if (isAuthChecking) {
        return null;
      }

      if (!isUserLoggedIn) {
        return isPublicRoute ? null : AppRoutes.login;
      }

      if (isGuestRestrictedRoute) {
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
          final email =
              state.uri.queryParameters['email'] ??
              extra['email'] as String? ??
              '';
          final token =
              state.uri.queryParameters['token'] ??
              extra['token'] as String? ??
              '';

          return ResetPasswordPage(email: email, token: token);
        },
      ),
      GoRoute(
        path: AppRoutes.calculator,
        builder: (context, state) => const CalculatorPage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.termsAndConditions,
        builder: (context, state) => const TermsAndConditionsPage(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        builder: (context, state) => const FAQPage(),
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
                builder: (context, state) => const SupportPage(),
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
