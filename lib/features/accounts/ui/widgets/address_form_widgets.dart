import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';
import 'package:logistic_by_strom/features/accounts/data/models/user_address.dart';

class AddressSectionTitle extends StatelessWidget {
  final String title;
  const AddressSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral900,
        ),
      ),
    );
  }
}

class AddressTypeSelector extends StatelessWidget {
  final AddressType selectedType;
  final ValueChanged<AddressType> onTypeChanged;

  const AddressTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AddressType.values.map((type) {
        final isSelected = selectedType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTypeChanged(type),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.neutral200,
                ),
              ),
              child: Center(
                child: Text(
                  type.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.white : AppColors.neutral500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AddressFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AddressFormTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
    );
  }
}

class AddressLocationDropdown extends StatelessWidget {
  final int? selectedLocationId;
  final List<Map<String, dynamic>> locations;
  final ValueChanged<int?> onChanged;

  const AddressLocationDropdown({
    super.key,
    required this.selectedLocationId,
    required this.locations,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<int>(
      label: 'Location',
      hint: 'Select Location',
      value: selectedLocationId,
      items: locations.map((l) => l['id'] as int).toList(),
      itemLabelBuilder: (id) =>
          locations.firstWhere((l) => l['id'] == id)['name'],
      onChanged: onChanged,
      validator: (v) => v == null ? 'Required' : null,
    );
  }
}

class AddressDefaultSwitch extends StatelessWidget {
  final bool isDefault;
  final ValueChanged<bool> onChanged;

  const AddressDefaultSwitch({
    super.key,
    required this.isDefault,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set as Default',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
              const Text(
                'This address will be used by default for shipments',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: isDefault,
          activeThumbColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class AddressSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;
  final String label;

  const AddressSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: label,
      onPressed: onPressed,
      isLoading: isSubmitting,
      borderRadius: AppSpacing.radiusLg,
    );
  }
}
