import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/app/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/core/utils/validators.dart';
import 'package:logistic_by_strom/features/auth/data/delivery_zones.dart';
import 'package:logistic_by_strom/features/auth/data/models/delivery_zone.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';
import 'package:logistic_by_strom/features/auth/ui/view_models/auth_view_model.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_logo_header.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_shell.dart';
import 'package:logistic_by_strom/features/auth/ui/widgets/auth_text_field.dart';

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
  bool _isRegistering = false;
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
        const SnackBar(
          content: Text(
            'Accept Terms & Conditions & Privacy Policy to continue',
          ),
        ),
      );
      return;
    }

    setState(() => _isRegistering = true);

    try {
      final RegistrationResponse response = await ref
          .read(authViewModelProvider.notifier)
          .register(
            name: _fullName,
            email: _emailController.text,
            phone: _mobileController.text,
            address: _fullAddress,
            password: _passwordController.text,
            countryId: _selectedCountryId,
            locationId: _selectedDeliveryZone.id
          );

      if (!mounted) return;

      final message =
          response.message ??
          'Registration successful. Continue with OTP verification.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration Failed: $e')));
    } finally {
      if (mounted) {
        setState(() => _isRegistering = false);
      }
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
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
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
                onPressed: _isRegistering ? null : _submit,
                child: _isRegistering
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
    required this.onDeliveryZoneChanged,
  });

  final TextEditingController firstNameController;
  final TextEditingController surnameController;
  final TextEditingController emailController;
  final int selectedCountryId;
  final DeliveryZone selectedDeliveryZone;
  final TextEditingController streetAddressController;
  final ValueChanged<DeliveryZone?> onDeliveryZoneChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: 'First Name',
          hintText: 'Enter first name',
          controller: firstNameController,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.required(value, 'First name'),
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Surname',
          hintText: 'Enter surname',
          controller: surnameController,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.required(value, 'Surname'),
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Email Address',
          hintText: 'Enter email address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
        ),
        const SizedBox(height: 22),
        AppDropdownField<int>(
          label: 'Country',
          hintText: 'Select country',
          items: _countries.map((country) => country.id).toList(),
          value: selectedCountryId,
          itemLabelBuilder: (id) =>
              _countries.firstWhere((country) => country.id == id).name,
          onChanged: null,
        ),
        const SizedBox(height: 22),
        AppDropdownField<DeliveryZone>(
          label: 'Delivery Zone',
          hintText: 'Select delivery zone',
          items: deliveryZones,
          value: selectedDeliveryZone,
          itemLabelBuilder: (zone) => zone.label,
          onChanged: onDeliveryZoneChanged,
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Street Address',
          hintText: 'Enter street address',
          controller: streetAddressController,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.required(value, 'Street address'),
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
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: 'Mobile Number',
          hintText: 'Enter mobile number',
          controller: mobileController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: Validators.mobile,
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
