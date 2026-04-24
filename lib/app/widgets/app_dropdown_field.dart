import 'package:flutter/material.dart';

import 'package:logistic_by_strom/app/theme/app_colors.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    required this.label,
    required this.hintText,
    required this.items,
    required this.itemLabelBuilder,
    super.key,
    this.value,
    this.onChanged,
    this.validator,
  });

  final String label;
  final String hintText;
  final List<T> items;
  final T? value;
  final String Function(T item) itemLabelBuilder;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonFormField<T>(
      initialValue: value,
      isDense: false,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.inputHint,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.neutral100.withValues(alpha: 0.5),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabelBuilder(item),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
