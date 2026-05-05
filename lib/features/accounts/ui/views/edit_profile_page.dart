import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/features/accounts/ui/view_models/accounts_view_model.dart';

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
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountsViewModelProvider).value;

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutral900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.neutral900,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            // Avatar with Edit Icon
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: AppColors.secondaryContainer,
                      backgroundImage: profile?.profileImageUrl != null
                          ? NetworkImage(profile!.profileImageUrl!)
                          : null,
                      child: profile?.profileImageUrl == null
                          ? const Icon(Icons.person,
                              size: 70, color: AppColors.secondary)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Name Fields in a Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'First name',
                    controller: _firstNameController,
                    hint: 'First name',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildInputField(
                    label: 'Last name',
                    controller: _lastNameController,
                    hint: 'Last name',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Email Field
            _buildInputField(
              label: 'Email',
              controller: _emailController,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Phone Field
            _buildInputField(
              label: 'Phone Number',
              controller: _phoneController,
              hint: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: AppSpacing.xxl * 2),
            
            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement update logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(
                color: AppColors.neutral200.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
