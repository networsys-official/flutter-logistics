import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/social_auth_callback_view_model.dart';

class SocialAuthCallbackPage extends ConsumerStatefulWidget {
  const SocialAuthCallbackPage({
    super.key,
    required this.token,
    required this.userJson,
  });

  final String? token;
  final String? userJson;

  @override
  ConsumerState<SocialAuthCallbackPage> createState() =>
      _SocialAuthCallbackPageState();
}

class _SocialAuthCallbackPageState extends ConsumerState<SocialAuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(socialAuthCallbackViewModelProvider.notifier).handleCallback(
            token: widget.token,
            userJson: widget.userJson,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(socialAuthCallbackViewModelProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: state.when(
            loading: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  'Completing Google Sign In...',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please wait while we set up your secure session.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral700,
                  ),
                ),
              ],
            ),
            error: (err, stack) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  'Authentication Error',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral700,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
            data: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  'Redirecting...',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
