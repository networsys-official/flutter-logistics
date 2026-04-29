import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/constants/strings/auth_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';


import 'package:logistic_by_strom/core/utils/validators.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/login_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_text_field.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/google_sign_in_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(loginViewModelProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen(loginViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${ErrorStrings.loginFailed}$e')),
          );
        },
      );
    });

    return AuthShell(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthLogoHeader(title: AuthStrings.loginTitle),
            const SizedBox(height: 42),
            AuthTextField(
              label: AuthStrings.emailAddress,
              hintText: AuthStrings.emailAddressHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
            ),
            const SizedBox(height: 22),
            AuthTextField(
              label: AuthStrings.password,
              hintText: AuthStrings.passwordHint,
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              validator: Validators.password,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
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
                onPressed: () => context.push(AppRoutes.forgotPassword),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.neutral900,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  AuthStrings.forgotPassword,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: loginState.isLoading ? null : _submit,
              child: loginState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(AuthStrings.loginButton),
            ),
            const SizedBox(height: 26),
            Text(
              AuthStrings.orLoginWith,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            const GoogleSignInButton(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AuthStrings.dontHaveAccount, style: textTheme.bodyMedium),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.register),
                  child: Text(
                    AuthStrings.signUp,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
