import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/shared/widgets/app_button.dart';
import 'package:logistic_by_strom/shared/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/shared/widgets/app_text_field.dart';

class AddShipmentForm extends StatefulWidget {
  const AddShipmentForm({super.key});

  @override
  State<AddShipmentForm> createState() => _AddShipmentFormState();
}

class _AddShipmentFormState extends State<AddShipmentForm> {
  final _trackingController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _trackingController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _UploadOptionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Tracking Number',
          controller: _trackingController,
          hint: 'Enter tracking number',
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Date',
          controller: _dateController,
          hint: 'Select Date',
          suffixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCalendar03,
            color: AppColors.neutral500,
            size: 20,
          ),
          readOnly: true,
          onTap: () {
            // Implement date picker
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<String>(
          label: 'Store/Supplier',
          hint: 'Select Store/Supplier',
          dropdownItems: ['Amazon', 'eBay', 'AliExpress', 'Walmart'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<String>(
          label: 'Commodity',
          hint: 'Select Commodity',
          dropdownItems: ['Electronics', 'Clothing', 'Furniture', 'Others'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdownField<String>(
          label: 'Price',
          hint: 'Select Price Range',
          dropdownItems: ['\$0 - \$100', '\$100 - \$500', '\$500+'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Note for packages',
          controller: _noteController,
          hint: 'Enter your note here...',
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildUploadAction(),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          text: 'Next',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildUploadAction() {
    return InkWell(
      onTap: _showUploadOptions,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedUpload01,
              color: AppColors.primary,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'Upload Receipt',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadOptionBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select upload option',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 32),
          _buildOption(
            context,
            icon: HugeIcons.strokeRoundedCamera01,
            label: 'Take a photo',
            color: AppColors.primary,
            bgColor: const Color(0xFFE8F5E9),
          ),
          const SizedBox(height: 16),
          _buildOption(
            context,
            icon: HugeIcons.strokeRoundedImage01,
            label: 'Choose from gallery',
            color: AppColors.secondary,
            bgColor: const Color(0xFFD6EEF4),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required dynamic icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.neutral200.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.neutral200,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
