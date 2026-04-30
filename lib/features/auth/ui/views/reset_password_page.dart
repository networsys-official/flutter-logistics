import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/constants/strings/auth_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/utils/error_message.dart';
import 'package:logistic_by_strom/core/utils/validators.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/forgot_password_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_text_field.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.token,
  });

  final String email;
  final String token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(forgotPasswordViewModelProvider.notifier)
          .resetPassword(
            email: widget.email,
            token: widget.token,
            newPassword: _passwordController.text,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AuthStrings.passwordResetSuccess)),
        );
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(forgotPasswordViewModelProvider);
    final error = state.error;

    ref.listen(forgotPasswordViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessageFrom(e, fallback: ErrorStrings.somethingWentWrong),
              ),
            ),
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
            const AuthLogoHeader(title: AuthStrings.resetPasswordTitle),
            const SizedBox(height: 12),
            Text(
              AuthStrings.resetPasswordSubtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 42),
            AuthTextField(
              label: AuthStrings.newPassword,
              hintText: AuthStrings.newPasswordHint,
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              validator: Validators.password,
              errorText: fieldErrorFrom(error, 'password'),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            const SizedBox(height: 22),
            AuthTextField(
              label: AuthStrings.confirmPassword,
              hintText: AuthStrings.confirmPasswordHint,
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              validator: (value) =>
                  Validators.confirmPassword(value, _passwordController.text),
              errorText: fieldErrorFrom(error, 'password_confirmation'),
              suffixIcon: IconButton(
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: state.isLoading ? null : _submit,
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(AuthStrings.updatePassword),
            ),
          ],
        ),
      ),
    );
  }
}
