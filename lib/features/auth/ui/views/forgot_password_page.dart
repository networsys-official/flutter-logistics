import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/constants/strings/auth_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';

import 'package:logistic_by_strom/core/utils/error_message.dart';
import 'package:logistic_by_strom/core/utils/validators.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/forgot_password_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_text_field.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(forgotPasswordViewModelProvider.notifier)
          .forgotPassword(_emailController.text.trim());

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AuthStrings.resetLinkSent),
            duration: Duration(seconds: 5),
          ),
        );
        // Optionally go back to login after some delay or immediately
        // context.pop();
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
            const AuthLogoHeader(title: AuthStrings.forgotPasswordTitle),
            const SizedBox(height: 12),
            Text(
              AuthStrings.forgotPasswordSubtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 42),
            AuthTextField(
              label: AuthStrings.emailAddress,
              hintText: AuthStrings.emailAddressHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
              errorText: fieldErrorFrom(error, 'email'),
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
                  : const Text(AuthStrings.sendOtp),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(AuthStrings.logIn),
            ),
          ],
        ),
      ),
    );
  }
}
