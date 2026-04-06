import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/core/utils/validators.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/auth_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_text_field.dart';

const _addressTypes = ['home', 'office', 'warehouse', 'other'];

const _countries = [
  (id: 1, name: 'Bahamas (Nassau)'),
  (id: 2, name: 'United States'),
  (id: 3, name: 'United Kingdom'),
  (id: 4, name: 'United Arab Emirates'),
  (id: 5, name: 'Singapore'),
];

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Ephemeral UI state only — these don't belong in ViewModel
  int _currentStep = 0;
  String? _selectedType;
  int? _selectedCountryId = 1;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressLine1Controller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    if (_currentStep == 0 && _selectedType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Type is required')));
      return false;
    }

    if (_currentStep == 1 && _selectedCountryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Country is required')));
      return false;
    }

    return true;
  }

  void _goToNextStep() {
    if (!_validateCurrentStep()) return;
    setState(() => _currentStep = 1);
  }

  Future<void> _submit() async {
    if (!_validateCurrentStep()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Accept Terms & Conditions & Privacy Policy to continue',
          ),
        ),
      );
      return;
    }


    await ref
        .read(authViewModelProvider.notifier)
        .register(
          name: _nameController.text,
          email: _emailController.text,
          mobile: _mobileController.text,
          address: _addressLine1Controller.text,
          password: _passwordController.text,
          addressType: _selectedType!,
          countryId: _selectedCountryId!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (state) {
          if (state.isLoggedIn) context.go(AppRoutes.dashboard);
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Registration Failed: $e')));
        },
        loading: () {},
      );
    });

    return AuthShell(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
              return;
            }
            context.go(AppRoutes.login);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthLogoHeader(title: 'SIGN UP'),
            const SizedBox(height: 18),
            Text(
              _currentStep == 0 ? 'Step 1 of 2' : 'Step 2 of 2',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.authPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _currentStep == 0 ? 0.5 : 1,
              backgroundColor: AppColors.authPrimary.withValues(alpha: 0.16),
              color: AppColors.authPrimary,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 32),
            if (_currentStep == 0)
              _StepOne(
                nameController: _nameController,
                emailController: _emailController,
                mobileController: _mobileController,
                selectedType: _selectedType,
                onTypeChanged: (v) => setState(() => _selectedType = v),
              ),
            if (_currentStep == 1)
              _StepTwo(
                addressController: _addressLine1Controller,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                selectedCountryId: _selectedCountryId,
                obscurePassword: _obscurePassword,
                obscureConfirmPassword: _obscureConfirmPassword,
                acceptedTerms: _acceptedTerms,
                onCountryChanged: (v) => setState(() => _selectedCountryId = v),
                onObscurePasswordToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                onObscureConfirmPasswordToggle: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
                onTermsChanged: (v) =>
                    setState(() => _acceptedTerms = v ?? false),
                textTheme: textTheme,
              ),
            const SizedBox(height: 16),
            if (_currentStep == 0)
              ElevatedButton(
                onPressed: _goToNextStep,
                child: const Text('NEXT'),
              ),
            if (_currentStep == 1) ...[
              ElevatedButton(
                onPressed: authState.isLoading ? null : _submit,
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('SIGN UP'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: const Text('BACK'),
              ),
            ],
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private widget — Step 1
// ✅ Extracted as separate widget class (not helper method)
// ---------------------------------------------------------------------------

class _StepOne extends StatelessWidget {
  const _StepOne({
    required this.nameController,
    required this.emailController,
    required this.mobileController,
    required this.selectedType,
    required this.onTypeChanged,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final String? selectedType;
  final ValueChanged<String?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: 'Name',
          hintText: 'Enter full name',
          controller: nameController,
          textInputAction: TextInputAction.next,
          validator: Validators.name,
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Email',
          hintText: 'Enter email address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Mobile Number',
          hintText: 'Enter mobile number',
          controller: mobileController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: Validators.mobile,
        ),
        const SizedBox(height: 22),
        DropdownButtonFormField<String>(
          initialValue: selectedType,
          isDense: false,
          decoration: _fieldDecoration(
            context,
            label: 'Type',
            hint: 'Select address type',
          ),
          items: _addressTypes
              .map(
                (type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type[0].toUpperCase() + type.substring(1),
                    style: textTheme.bodyMedium,
                  ),
                ),
              )
              .toList(),
          onChanged: onTypeChanged,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private widget — Step 2
// ---------------------------------------------------------------------------

class _StepTwo extends StatelessWidget {
  const _StepTwo({
    required this.addressController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedCountryId,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.acceptedTerms,
    required this.onCountryChanged,
    required this.onObscurePasswordToggle,
    required this.onObscureConfirmPasswordToggle,
    required this.onTermsChanged,
    required this.textTheme,
  });

  final TextEditingController addressController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final int? selectedCountryId;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptedTerms;
  final ValueChanged<int?> onCountryChanged;
  final VoidCallback onObscurePasswordToggle;
  final VoidCallback onObscureConfirmPasswordToggle;
  final ValueChanged<bool?> onTermsChanged;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          initialValue: selectedCountryId,
          isDense: false,
          decoration: _fieldDecoration(
            context,
            label: 'Country',
            hint: 'Select country',
          ),
          items: _countries
              .map(
                (country) => DropdownMenuItem<int>(
                  value: country.id,
                  child: Text(country.name),
                ),
              )
              .toList(),
          onChanged: onCountryChanged,
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Address Line',
          hintText: 'Enter address line',
          controller: addressController,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.required(value, 'Address line'),
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Password',
          hintText: 'Enter password',
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.next,
          validator: Validators.password,
          suffixIcon: IconButton(
            onPressed: onObscurePasswordToggle,
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Confirm Password',
          hintText: 'Enter confirm password',
          controller: confirmPasswordController,
          obscureText: obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          validator: (value) =>
              Validators.confirmPassword(value, passwordController.text),
          suffixIcon: IconButton(
            onPressed: onObscureConfirmPasswordToggle,
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        const SizedBox(height: 18),
        InkWell(
          onTap: () => onTermsChanged(!acceptedTerms),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(value: acceptedTerms, onChanged: onTermsChanged),
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
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helper — dropdown decoration (DRY principle)
// ---------------------------------------------------------------------------

InputDecoration _fieldDecoration(
  BuildContext context, {
  required String label,
  required String hint,
}) {
  final textTheme = Theme.of(context).textTheme;

  return InputDecoration(
    labelText: label,
    hintText: hint,
    alignLabelWithHint: true,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: textTheme.bodyMedium?.copyWith(
      color: AppColors.authMuted,
      fontWeight: FontWeight.w500,
    ),
    floatingLabelStyle: textTheme.bodyMedium?.copyWith(
      color: AppColors.authPrimary,
      fontWeight: FontWeight.w700,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.authFieldBorder, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.authPrimary, width: 1.5),
    ),
    filled: true,
    fillColor: AppColors.cloud100.withValues(alpha: 0.5),
  );
}
