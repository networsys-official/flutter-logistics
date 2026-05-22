import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/models/auth_state.dart';
import 'package:logistic_by_strom/core/models/user_model.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

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
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processLogin();
    });
  }

  Future<void> _processLogin() async {
    final token = widget.token;
    final userJson = widget.userJson;

    if (token == null || token.isEmpty || userJson == null || userJson.isEmpty) {
      setState(() {
        _errorMessage = 'Authentication failed: Invalid credentials returned.';
        _isLoading = false;
      });
      return;
    }

    try {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      final user = UserModel.fromJson(userData);
      final authState = AuthState(user: user, token: token);

      await ref.read(authProvider.notifier).updateSession(authState);
      // Once the session is updated, the appRouter listener on authProvider
      // will trigger the redirect. GoRouter will automatically take the user home.
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to parse user details: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? Column(
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
                )
              : Column(
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
                      _errorMessage ?? 'An unknown error occurred.',
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
        ),
      ),
    );
  }
}
