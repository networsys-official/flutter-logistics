import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';
import 'package:logistic_by_strom/core/widgets/app_button.dart';
import 'package:logistic_by_strom/core/widgets/app_dropdown_field.dart';
import 'package:logistic_by_strom/core/widgets/app_text_field.dart';

class CalculatorInputGrid extends StatelessWidget {
  const CalculatorInputGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Dimensions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.neutral900,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(child: AppTextField(label: 'Length', hint: '0.00')),
            SizedBox(width: AppSpacing.md),
            Expanded(child: AppTextField(label: 'Width', hint: '0.00')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(child: AppTextField(label: 'Height', hint: '0.00')),
            SizedBox(width: AppSpacing.md),
            Expanded(child: AppTextField(label: 'Weight', hint: '0 kg')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(label: 'Price', hint: '\$0.00'),
        const SizedBox(height: AppSpacing.md),
        AppDropdownField<String>(
          label: 'Item Type',
          hint: 'Select Item Type',
          dropdownItems: ['iPhone', 'Laptop', 'Electronics', 'Furniture', 'Clothing']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {},
        ),
        const SizedBox(height: AppSpacing.lg),
        const _ShippingOptions(),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          text: 'Calculate',
          onPressed: () {},
        ),
      ],
    );
  }
}

class _ShippingOptions extends StatefulWidget {
  const _ShippingOptions();

  @override
  State<_ShippingOptions> createState() => _ShippingOptionsState();
}

class _ShippingOptionsState extends State<_ShippingOptions> {
  String selectedOption = 'Standard';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Shipping Method',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral500,
            ),
          ),
        ),
        Row(
          children: [
            _buildOption('Standard', 'Standard'),
            const SizedBox(width: 24),
            _buildOption('Priority', 'Priority'),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(String label, String value) {
    final isSelected = selectedOption == value;
    return InkWell(
      onTap: () => setState(() => selectedOption = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.neutral200,
                width: 2,
              ),
            ),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.neutral900 : AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
