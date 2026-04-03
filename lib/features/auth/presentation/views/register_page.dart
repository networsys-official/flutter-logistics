import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/features/auth/presentation/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/presentation/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthShell(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.login),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthLogoHeader(title: 'SIGN UP'),
          const SizedBox(height: 38),
          AuthTextField(
            label: 'Name',
            hintText: 'Enter mobile number',
            controller: _nameController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 22),
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
            textInputAction: TextInputAction.next,
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
          const SizedBox(height: 22),
          AuthTextField(
            label: 'Confirm Password',
            hintText: 'Enter confirm password',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: () {
              setState(() {
                _acceptedTerms = !_acceptedTerms;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptedTerms = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(
                      'Accept Terms & Conditions & Privacy Policy of App',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.authPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _acceptedTerms ? () => context.go(AppRoutes.dashboard) : null,
            child: const Text('SIGN UP'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account ? ', style: textTheme.bodyMedium),
              GestureDetector(
                onTap: () => context.go(AppRoutes.login),
                child: Text(
                  'Log In',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.authPrimary,
                    fontWeight: FontWeight.w800,
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
