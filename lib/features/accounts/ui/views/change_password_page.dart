import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Update Password',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  _buildPasswordField(
                    label: 'Current Password',
                    controller: _currentPasswordController,
                    hint: 'Enter current password',
                    isVisible: _isCurrentPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPasswordField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    hint: 'Enter new password',
                    isVisible: _isNewPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPasswordField(
                    label: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    hint: 'Confirm new password',
                    isVisible: _isConfirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement password update logic
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Update Password',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.neutral100,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: AppColors.neutral900,
              ),
              const SizedBox(width: 8),
              Text(
                'Change Password',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral500,
            ),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: !isVisible,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.neutral500,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.neutral200.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
