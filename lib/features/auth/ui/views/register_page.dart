import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/auth_strings.dart';
import 'package:logistic_by_strom/core/constants/strings/error_strings.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

import 'package:logistic_by_strom/core/utils/error_message.dart';
import 'package:logistic_by_strom/core/utils/validators.dart';
import 'package:logistic_by_strom/features/auth/data/delivery_zones.dart';
import 'package:logistic_by_strom/features/auth/data/models/delivery_zone.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/register_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_text_field.dart';
import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';

const _countries = [(id: 1, name: 'Bahamas')];

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _currentStep = 0;
  final int _selectedCountryId = 1;
  DeliveryZone _selectedDeliveryZone = deliveryZones.first;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _streetAddressController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

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
        const SnackBar(content: Text(AuthStrings.acceptTermsError)),
      );
      return;
    }

    final response = await ref
        .read(registerViewModelProvider.notifier)
        .register(
          name: _fullName,
          email: _emailController.text,
          phone: _mobileController.text,
          address: _fullAddress,
          password: _passwordController.text,
          countryId: _selectedCountryId,
          locationId: _selectedDeliveryZone.id,
        );

    if (response != null && mounted) {
      final message = response.message ?? AuthStrings.registrationSuccess;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      context.push(
        AppRoutes.otp,
        extra: {'identifier': _emailController.text.trim(), 'type': 'email'},
      );
    }
  }

  String get _fullName {
    return [
      _firstNameController.text.trim(),
      _surnameController.text.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
  }

  String get _selectedCountryName {
    final selected = _countries.where(
      (country) => country.id == _selectedCountryId,
    );
    if (selected.isEmpty) {
      return 'Bahamas';
    }
    return selected.first.name;
  }

  String get _fullAddress {
    return [
      _streetAddressController.text.trim(),
      _selectedDeliveryZone.label,
      _selectedCountryName,
    ].where((part) => part.isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final registerState = ref.watch(registerViewModelProvider);
    final registerError = registerState.error;

    ref.listen(registerViewModelProvider, (previous, next) {
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
            const AuthLogoHeader(title: AuthStrings.signUpTitle),
            SizedBox(height: AppSpacing.md),
            Text(
              _currentStep == 0 ? AuthStrings.step1of2 : AuthStrings.step2of2,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(
              value: _currentStep == 0 ? 0.5 : 1,
              backgroundColor: AppColors.primary.withValues(alpha: 0.16),
              color: AppColors.primary,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 32),
            if (_currentStep == 0)
              _StepOne(
                firstNameController: _firstNameController,
                surnameController: _surnameController,
                emailController: _emailController,
                selectedCountryId: _selectedCountryId,
                selectedDeliveryZone: _selectedDeliveryZone,
                streetAddressController: _streetAddressController,
                error: registerError,
                onDeliveryZoneChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedDeliveryZone = value);
                },
              ),
            if (_currentStep == 1)
              _StepTwo(
                mobileController: _mobileController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                obscurePassword: _obscurePassword,
                obscureConfirmPassword: _obscureConfirmPassword,
                acceptedTerms: _acceptedTerms,
                onObscurePasswordToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                onObscureConfirmPasswordToggle: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
                onTermsChanged: (v) =>
                    setState(() => _acceptedTerms = v ?? false),
                error: registerError,
                textTheme: textTheme,
              ),
            const SizedBox(height: AppSpacing.md),
            if (_currentStep == 0)
              ElevatedButton(
                onPressed: _goToNextStep,
                child: const Text(AppStrings.next),
              ),
            if (_currentStep == 1) ...[
              ElevatedButton(
                onPressed: registerState.isLoading ? null : _submit,
                child: registerState.isLoading
                    ? const SizedBox(
                        height: AppSpacing.lg,
                        width: AppSpacing.lg,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(AuthStrings.signUpButton),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: const Text(AppStrings.back),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AuthStrings.alreadyHaveAccount,
                  style: textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: Text(
                    AuthStrings.logIn,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
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

class _StepOne extends StatelessWidget {
  const _StepOne({
    required this.firstNameController,
    required this.surnameController,
    required this.emailController,
    required this.selectedCountryId,
    required this.selectedDeliveryZone,
    required this.streetAddressController,
    required this.error,
    required this.onDeliveryZoneChanged,
  });

  final TextEditingController firstNameController;
  final TextEditingController surnameController;
  final TextEditingController emailController;
  final int selectedCountryId;
  final DeliveryZone selectedDeliveryZone;
  final TextEditingController streetAddressController;
  final Object? error;
  final ValueChanged<DeliveryZone?> onDeliveryZoneChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: AuthStrings.firstName,
          hintText: AuthStrings.firstNameHint,
          controller: firstNameController,
          textInputAction: TextInputAction.next,
          validator: (value) =>
              Validators.required(value, AuthStrings.firstName),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthTextField(
          label: AuthStrings.surname,
          hintText: AuthStrings.surnameHint,
          controller: surnameController,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.required(value, AuthStrings.surname),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthTextField(
          label: AuthStrings.emailAddress,
          hintText: AuthStrings.emailAddressHint,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
          errorText: fieldErrorFrom(error, 'email'),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<int>(
          label: AuthStrings.country,
          hint: AuthStrings.countryHint,
          items: _countries.map((country) => country.id).toList(),
          value: selectedCountryId,
          itemLabelBuilder: (id) =>
              _countries.firstWhere((country) => country.id == id).name,
          onChanged: null,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<DeliveryZone>(
          label: AuthStrings.deliveryZone,
          hint: AuthStrings.deliveryZoneHint,
          items: deliveryZones,
          value: selectedDeliveryZone,
          itemLabelBuilder: (zone) => zone.label,
          onChanged: onDeliveryZoneChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthTextField(
          label: AuthStrings.streetAddress,
          hintText: AuthStrings.streetAddressHint,
          controller: streetAddressController,
          textInputAction: TextInputAction.next,
          validator: (value) =>
              Validators.required(value, AuthStrings.streetAddress),
          errorText: fieldErrorFrom(error, 'address_line_1'),
        ),
      ],
    );
  }
}

class _StepTwo extends StatelessWidget {
  const _StepTwo({
    required this.mobileController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.acceptedTerms,
    required this.onObscurePasswordToggle,
    required this.onObscureConfirmPasswordToggle,
    required this.onTermsChanged,
    required this.error,
    required this.textTheme,
  });

  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptedTerms;
  final VoidCallback onObscurePasswordToggle;
  final VoidCallback onObscureConfirmPasswordToggle;
  final ValueChanged<bool?> onTermsChanged;
  final Object? error;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: AuthStrings.mobileNumber,
          hintText: AuthStrings.mobileNumberHint,
          controller: mobileController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: Validators.mobile,
          errorText: fieldErrorFrom(error, 'phone'),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthTextField(
          label: AuthStrings.password,
          hintText: AuthStrings.passwordHint,
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.next,
          validator: Validators.password,
          errorText: fieldErrorFrom(error, 'password'),
          suffixIcon: IconButton(
            onPressed: onObscurePasswordToggle,
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthTextField(
          label: AuthStrings.confirmPassword,
          hintText: AuthStrings.confirmPasswordHint,
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
        const SizedBox(height: AppSpacing.md),
        InkWell(
          onTap: () => onTermsChanged(!acceptedTerms),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(value: acceptedTerms, onChanged: onTermsChanged),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Text(
                    AuthStrings.acceptTerms,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
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
