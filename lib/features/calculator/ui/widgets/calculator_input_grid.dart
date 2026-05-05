import 'package:flutter/material.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';

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
            Expanded(child: _InputField(label: 'Length', hint: '0.00')),
            SizedBox(width: AppSpacing.md),
            Expanded(child: _InputField(label: 'Width', hint: '0.00')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: [
            Expanded(child: _InputField(label: 'Height', hint: '0.00')),
            SizedBox(width: AppSpacing.md),
            Expanded(child: _InputField(label: 'Weight', hint: '0 kg')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const _InputField(label: 'Price', hint: '\$0.00'),
        const SizedBox(height: AppSpacing.md),
        const _DropdownField(
          label: 'Item Type',
          hint: 'Select Item Type',
          items: ['iPhone', 'Laptop', 'Electronics', 'Furniture', 'Clothing'],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _ShippingOptions(),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Calculate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

// ... (rest of the file remains similar but with updated styling)
class _InputField extends StatelessWidget {
  final String label;
  final String hint;

  const _InputField({required this.label, required this.hint});

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
        TextField(
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.items,
  });

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral500,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.neutral900,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
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
          items: widget.items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
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