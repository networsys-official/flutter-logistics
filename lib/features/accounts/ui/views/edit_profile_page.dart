import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/utils/file_utils.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_profile.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/accounts_view_model.dart';
import 'package:logistic_by_strom/features/accounts/ui/widgets/avatar_section_widgets.dart';
import 'package:logistic_by_strom/core/widgets/app_app_bar.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';

import '../widgets/image_source_bottom_sheet.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;

  String? _selectedGender;
  String? _selectedLanguage;
  File? _imageFile;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _languages = [
    'English',
    'Espanol',
    'Francais',
    'Deutsch',
    'Dansk',
    'Suomi',
    'Nederlands',
    'Kreyol Ayisyen',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(accountsViewModelProvider).value;
    final names = profile?.name.split(' ') ?? ['', ''];
    _firstNameController = TextEditingController(text: names.first);
    _lastNameController = TextEditingController(
      text: names.length > 1 ? names.sublist(1).join(' ') : '',
    );
    _emailController = TextEditingController(text: profile?.email);
    _phoneController = TextEditingController(text: profile?.phone);

    // Convert YYYY-MM-DD from backend to DD/MM/YYYY for UI
    String? displayDob;
    if (profile?.dob != null) {
      try {
        final date = DateTime.parse(profile!.dob!);
        displayDob = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        displayDob = profile?.dob;
      }
    }
    _dobController = TextEditingController(text: displayDob);

    _selectedGender = _capitalize(profile?.gender) ?? 'Male';
    _selectedLanguage = _capitalize(profile?.language) ?? 'English';
  }

  String? _capitalize(String? value) {
    if (value == null || value.isEmpty) return null;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _handleImageSelection() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ImageSourceBottomSheet(
        onCameraTap: () async {

          await Future.delayed(const Duration(milliseconds: 200));

          final image = await FileUtils.captureFromCamera();

          if (image != null && mounted) {
            setState(() => _imageFile = image);
          }
        },
        onGalleryTap: () async {
          final image = await FileUtils.pickImage();
          if (image != null) setState(() => _imageFile = File(image.path));
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.neutral900,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _updateProfile() async {
    final name = '${_firstNameController.text} ${_lastNameController.text}'
        .trim();
    final success = await ref
        .read(accountsViewModelProvider.notifier)
        .updateProfile(
          name: name,
          phone: _phoneController.text,
          gender: _selectedGender,
          dob: _dobController.text,
          language: _selectedLanguage,
          imagePath: _imageFile?.path,
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountsViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: Column(
        children: [
          const AppAppBar(title: 'Edit Profile'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  AvatarSection(
                    imageFile: _imageFile,
                    profileImageUrl: accountState.value?.resolvedImageUrl,
                    onPickImage: _handleImageSelection,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'First Name',
                          controller: _firstNameController,
                          hint: 'First name',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppTextField(
                          label: 'Last Name',
                          controller: _lastNameController,
                          hint: 'Last name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'Email',
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedTick01,
                      color: AppColors.success,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    hint: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'Date of Birth',
                    controller: _dobController,
                    hint: 'DD/MM/YYYY',
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar01,
                      color: AppColors.neutral500,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Gender',
                          hint: 'Select Gender',
                          value: _selectedGender,
                          items: _genders,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Language',
                          hint: 'Language',
                          value: _selectedLanguage,
                          items: _languages,
                          onChanged: (val) =>
                              setState(() => _selectedLanguage = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  AppButton(text: 'Update Profile', onPressed: _updateProfile),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
