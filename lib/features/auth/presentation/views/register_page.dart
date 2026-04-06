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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int _currentStep = 0;
  String? _selectedType;
  int? _selectedCountryId = 1;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = true;

  static const _addressTypes = ['home', 'office', 'warehouse', 'other'];
  static const _countries = [
    (id: 1, name: 'Bahamas (Nassau)'),
    (id: 2, name: 'United States'),
    (id: 3, name: 'United Kingdom'),
    (id: 4, name: 'United Arab Emirates'),
    (id: 5, name: 'Singapore'),
  ];

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

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  String? _nameValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Name');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    final requiredError = _requiredValidator(value, 'Confirm password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  bool _validateCurrentStep() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }

    if (_currentStep == 0 && _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Type is required')),
      );
      return false;
    }

    if (_currentStep == 1 && _selectedCountryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Country is required')),
      );
      return false;
    }

    return true;
  }

  void _goToNextStep() {
    if (!_validateCurrentStep()) {
      return;
    }

    setState(() {
      _currentStep = 1;
    });
  }

  void _submit() {
    if (!_validateCurrentStep()) {
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Accept Terms & Conditions & Privacy Policy to continue'),
        ),
      );
      return;
    }

    context.go(AppRoutes.dashboard);
  }

  Widget _buildTypeDropdown() {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonFormField<String>(
      initialValue: _selectedType,
      isDense: false,
      decoration: InputDecoration(
        labelText: 'Type',
        hintText: 'Select address type',
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
      ),
      items: _addressTypes
          .map(
            (type) => DropdownMenuItem<String>(
              value: type,
              child: Text(type[0].toUpperCase() + type.substring(1)),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
    );
  }

  Widget _buildCountryDropdown() {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonFormField<int>(
      initialValue: _selectedCountryId,
      isDense: false,
      decoration: InputDecoration(
        labelText: 'Country',
        hintText: 'Select country',
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
      ),
      items: _countries
          .map(
            (country) => DropdownMenuItem<int>(
              value: country.id,
              child: Text(country.name),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCountryId = value;
        });
      },
    );
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: 'Name',
          hintText: 'Enter full name',
          controller: _nameController,
          textInputAction: TextInputAction.next,
          validator: _nameValidator,
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Email',
          hintText: 'Enter email address',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: _emailValidator,
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Mobile Number',
          hintText: 'Enter mobile number',
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: (value) => _requiredValidator(value, 'Mobile number'),
        ),
        const SizedBox(height: 22),
        _buildTypeDropdown(),
      ],
    );
  }

  Widget _buildStepTwo(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCountryDropdown(),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Address Line',
          hintText: 'Enter address line',
          controller: _addressLine1Controller,
          textInputAction: TextInputAction.next,
          validator: (value) => _requiredValidator(value, 'Address line'),
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Password',
          hintText: 'Enter password',
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          validator: _passwordValidator,
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
          validator: _confirmPasswordValidator,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
      ],
    );
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
              setState(() {
                _currentStep = 0;
              });
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
            if (_currentStep == 0) _buildStepOne(),
            if (_currentStep == 1) _buildStepTwo(textTheme),
            const SizedBox(height: 16),
            if (_currentStep == 0)
              ElevatedButton(
                onPressed: _goToNextStep,
                child: const Text('NEXT'),
              ),
            if (_currentStep == 1) ...[
              ElevatedButton(
                onPressed: _submit,
                child: const Text('SIGN UP'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 0;
                  });
                },
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
