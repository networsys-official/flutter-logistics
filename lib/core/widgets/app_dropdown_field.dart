import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T>? items;
  final List<DropdownMenuItem<T>>? dropdownItems;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? itemLabelBuilder;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    this.value,
    this.items,
    this.dropdownItems,
    this.onChanged,
    this.itemLabelBuilder,
  }) : assert(items != null || dropdownItems != null, 'Either items or dropdownItems must be provided');

  @override
  Widget build(BuildContext context) {
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
        DropdownButtonFormField<T>(
          initialValue: value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.neutral900,
          ),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
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
          ),
          items: dropdownItems ??
              items?.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabelBuilder?.call(item) ?? item.toString()),
                );
              }).toList(),
          onChanged: onChanged,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.neutral500,
            size: 24,
          ),
        ),
      ],
    );
  }
}
