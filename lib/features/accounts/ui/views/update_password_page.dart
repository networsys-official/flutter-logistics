import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/constants/strings/account_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/utils/error_message.dart';
import 'package:logistic_by_strom/core/utils/validators.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/update_password_view_model.dart';

class UpdatePasswordPage extends ConsumerStatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  ConsumerState<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends ConsumerState<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(updatePasswordViewModelProvider.notifier)
          .updatePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AccountStrings.passwordUpdatedSuccess)),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updatePasswordViewModelProvider);
    final error = state.error;

    ref.listen(updatePasswordViewModelProvider, (previous, next) {
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

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(title: AccountStrings.updatePasswordTitle),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      AccountStrings.updatePasswordTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.neutral900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a strong password to keep your account secure.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: AccountStrings.currentPassword,
                      controller: _currentPasswordController,
                      hint: 'Enter current password',
                      obscureText: !_isCurrentPasswordVisible,
                      validator: (value) => Validators.required(
                        value,
                        AccountStrings.currentPassword,
                      ),
                      errorText: fieldErrorFrom(error, 'current_password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isCurrentPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.neutral500,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _isCurrentPasswordVisible =
                              !_isCurrentPasswordVisible,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: AccountStrings.newPassword,
                      controller: _newPasswordController,
                      hint: 'Enter new password',
                      obscureText: !_isNewPasswordVisible,
                      validator: (value) => Validators.password(value),
                      errorText: fieldErrorFrom(error, 'password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.neutral500,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _isNewPasswordVisible = !_isNewPasswordVisible,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: AccountStrings.confirmPassword,
                      controller: _confirmPasswordController,
                      hint: 'Confirm new password',
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _newPasswordController.text,
                      ),
                      errorText: fieldErrorFrom(error, 'password_confirmation'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.neutral500,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    AppButton(
                      text: AccountStrings.updatePasswordButton,
                      isLoading: state.isLoading,
                      onPressed: state.isLoading ? null : _submit,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
