import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/features/auth/presentation/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/presentation/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:logistic_by_strom/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthLogoHeader(title: 'LOGIN'),
          const SizedBox(height: 42),
          AuthTextField(
            label: 'Mobile Number',
            hintText: 'Enter mobile number',
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 22),
          AuthTextField(
            label: 'Password',
            hintText: 'Enter password',
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.ink900,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.dashboard),
            child: const Text('Login'),
          ),
          const SizedBox(height: 26),
          Text(
            'or login with',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.ink700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          const GoogleSignInButton(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account? ', style: textTheme.bodyMedium),
              GestureDetector(
                onTap: () => context.go(AppRoutes.register),
                child: Text(
                  'Sign Up',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.authPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
